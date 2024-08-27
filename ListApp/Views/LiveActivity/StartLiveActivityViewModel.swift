import ActivityKit
import SwiftUI
import OSLog

@MainActor
final class StartLiveActivityViewModel: ObservableObject {
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
        self.setup(with: activity)
    }
    
    func onStartShoppingActivityButtonPressed() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let impendingBedtime = BasketBuddyWidgetAttributes(name: "World")
               
                let initialState = BasketBuddyWidgetAttributes.ContentState(itemCount: 2, nextItem: SimplifiedListItem(count: "1", name: "Waffles", unitAbbrv: "item", categoryName: "Bakery"))
                
                let activity = try Activity<BasketBuddyWidgetAttributes>.request(attributes: impendingBedtime, content: .init(state: initialState, staleDate: nil), pushType: .token)
               
                print("ACTIVITYID: \(activity.id)")
                self.setup(with: activity)
            } catch {
                print("Failed to start activity. \(error)")
                self.errorMessage = "Failed to start activity. \(String(describing: error))"
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
        
        let finalContent = BasketBuddyWidgetAttributes.ContentState(itemCount: 2, nextItem: SimplifiedListItem(count: "1", name: "Waffles", unitAbbrv: "item", categoryName: "Bakery"))
        
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
        self.currentActivity = activity
        self.activityViewState = .init(activityState: activity.activityState, contentState: activity.content.state)
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
    
    func sendPushToken(pushTokenString: String, frequentUpdateEnabled: Bool) async throws {}

    func cleanUpDismissedActivity() {
        self.currentActivity = nil
        self.activityViewState = nil
    }
    
}

extension Data {
    var hexadecimalString: String {
        self.reduce("") {
            $0 + String(format: "%02x", $1)
        }
    }
}
