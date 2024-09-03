import ActivityKit
import CoreData
import OSLog
import SwiftUI
import Combine

@MainActor
final class StartLiveActivityViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    @State private var listItems: [SimplifiedListItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private func observeCoreDataChanges() {
        CoreDataPublisher.shared.$dataDidChange
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateActivityFromViewContext()
            }
            .store(in: &cancellables)
    }
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        do {
            listItems = try ListItem.getSimplifiedListItemsForWidget(viewContext)
        } catch {
            print(error.localizedDescription)
        }
        
        observeCoreDataChanges()
    }
    
    struct ActivityViewState: Sendable {
        var activityState: ActivityState
        var contentState: BasketBuddyWidgetAttributes.ContentState
        var pushToken: String? = nil
        
        var shouldShowEndControls: Bool {
            switch activityState {
            case .active, .stale:
                return true
            case .ended, .dismissed:
                return false
            @unknown default:
                return false
            }
        }
        
        var updateControlDisabled = false
        
        var shouldShowUpdateControls: Bool {
            switch activityState {
            case .active, .stale:
                return true
            case .ended, .dismissed:
                return false
            @unknown default:
                return false
            }
        }
        
        var isStale: Bool {
            return activityState == .stale
        }
    }
    
    @Published var activityViewState: ActivityViewState? = nil
    @Published var errorMessage: String? = nil
    
    private var currentActivity: Activity<BasketBuddyWidgetAttributes>? = nil
    
    func loadImpendingBedtime() {
        let activityOfChoice = Activity<BasketBuddyWidgetAttributes>.activities.first
        guard let activity = activityOfChoice else { return }
        setup(with: activity)
    }
    
    func onStartShoppingActivityButtonPressed() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let basketBuddyAttributes = BasketBuddyWidgetAttributes()
              
                let items = try ListItem.getSimplifiedListItemsForWidget(viewContext)
                
                let nextItem: SimplifiedListItem
                if let item = items.first {
                    nextItem = item
                } else {
                    nextItem = SimplifiedListItem(count: "", name: "No Items Left!", unitAbbrv: nil, categoryName: nil)
                }
                
                
                
                let initialState = BasketBuddyWidgetAttributes.ContentState(itemCount: items.count, nextItem: nextItem)
                
                let activity = try Activity<BasketBuddyWidgetAttributes>.request(attributes: basketBuddyAttributes, content: .init(state: initialState, staleDate: nil), pushType: .token)
                
                setup(with: activity)
            } catch {
                print(error.localizedDescription)
                errorMessage = "Failed to start activity. \(String(describing: error))"
            }
        }
    }
    
    func onEndShoppingActivityButtonPressed(dismissTimeInterval: Double?) {
        Task {
            await self.endActivity(dismissTimeInterval: dismissTimeInterval)
        }
    }
    
    func endActivity(dismissTimeInterval: Double?) async {
        guard let activity = currentActivity else { return }
        
        let items = try? ListItem.getSimplifiedListItemsForWidget(viewContext)
        
        let nextItem: SimplifiedListItem
        if let item = items?.first {
            nextItem = item
        } else {
            nextItem = SimplifiedListItem(count: "", name: "No Items Left!", unitAbbrv: nil, categoryName: nil)
        }
        
        let finalContent = BasketBuddyWidgetAttributes.ContentState(itemCount: items?.count ?? 0, nextItem: nextItem)
        
        let dismissalPolicy: ActivityUIDismissalPolicy
        if let dismissTimeInterval = dismissTimeInterval {
            if dismissTimeInterval <= 0 {
                dismissalPolicy = .immediate
            } else {
                dismissalPolicy = .after(.now + dismissTimeInterval)
            }
        } else {
            dismissalPolicy = .default
        }
        
        await activity.end(ActivityContent(state: finalContent, staleDate: nil), dismissalPolicy: dismissalPolicy)
    }
    
    func setup(with activity: Activity<BasketBuddyWidgetAttributes>) {
        currentActivity = activity
        activityViewState = .init(activityState: activity.activityState, contentState: activity.content.state)
        observeActivity(for: activity)
    }
    
    func observeActivity(for activity: Activity<BasketBuddyWidgetAttributes>) {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { @MainActor in
                    for await activityState in activity.activityStateUpdates {
                        if activityState == .dismissed {
                            self.cleanUpDismissedActivity()
                        } else {
                            self.activityViewState?.activityState = activityState
                        }
                    }
                }
                
                group.addTask { @MainActor in
                    for await contentState in activity.contentUpdates {
                        self.activityViewState?.contentState = contentState.state
                    }
                }
                
                group.addTask { @MainActor in
                    for await pushToken in activity.pushTokenUpdates {
                        let pushTokenString = pushToken.hexadecimalString
                        
                        Logger().debug("New push token: \(pushTokenString)")
                        
                        do {
                            let frequentUpdateEnabled = ActivityAuthorizationInfo().frequentPushesEnabled
                            
                            try await self.sendPushToken(pushTokenString: pushTokenString, frequentUpdateEnabled: frequentUpdateEnabled)
                        } catch {
                            self.errorMessage = "Failed to send push token to server. \(String(describing: error))"
                        }
                    }
                }
            }
        }
    }
    
    func sendPushToken(pushTokenString _: String, frequentUpdateEnabled _: Bool) async throws {}
    
    func cleanUpDismissedActivity() {
        currentActivity = nil
        activityViewState = nil
    }
   
    func updateActivityFromViewContext() {
        Task {
            let items = try? ListItem.getSimplifiedListItemsForWidget(viewContext)
            await updateLiveActivity(updatedItems: items ?? [])
        }
    }
    
    func updateLiveActivity(updatedItems: [SimplifiedListItem]) async {
        guard let currentActivity = currentActivity else { return }
        
        let nextItem: SimplifiedListItem
        if let item = updatedItems.first {
            nextItem = item
        } else {
            nextItem = SimplifiedListItem(count: "", name: "No Items Left!", unitAbbrv: nil, categoryName: nil)
        }
        
        let contentState = BasketBuddyWidgetAttributes.ContentState(itemCount: updatedItems.count, nextItem: nextItem)
        
        await currentActivity.update(ActivityContent<BasketBuddyWidgetAttributes.ContentState>(state: contentState, staleDate: Date.now + 15))
    }
}

extension Data {
    var hexadecimalString: String {
        reduce("") {
            $0 + String(format: "%02x", $1)
        }
    }
}
