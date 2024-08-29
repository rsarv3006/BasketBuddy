import Foundation
import AppIntents
import ActivityKit

struct UpdateLiveActivityInfo: Codable, Hashable, Sendable {
    let itemCount: Int
    let nextItem: SimplifiedListItem
}

struct UpdateLiveActivityIntent: LiveActivityIntent {
    init() {}
    
    static var title: LocalizedStringResource = "Update Live Activity from App Changes"
    
    @Parameter(title: "recordId")
    var recordId: String
    
    init(recordId: String) {
        self.recordId = recordId
    }
   
    func perform() async throws -> some IntentResult {
        self.updateLiveActivity()
        return .result()
    }
    
    func updateLiveActivity() {
        guard let activity = Activity<BasketBuddyWidgetAttributes>.activities.first else { return }
        
        do {
            let items = try ListItem.getSimplifiedListItemsForWidget(PersistenceController.shared.container.viewContext)
            
            let nextItem: SimplifiedListItem
            if let item = items.first {
                nextItem = item
            } else {
                nextItem = SimplifiedListItem(count: "", name: "No Items Left!", unitAbbrv: nil, categoryName: nil)
            }
            
            Task {
                let contentState = BasketBuddyWidgetAttributes.ContentState(itemCount: items.count, nextItem: nextItem)
                
                await activity.update(ActivityContent<BasketBuddyWidgetAttributes.ContentState>(state: contentState, staleDate: Date.now + 15))
            }
        } catch {
            print("Failed to fetch latest entity: \(error)")
        }
    }
}

