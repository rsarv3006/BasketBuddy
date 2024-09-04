import AppIntents
import CoreData
import ActivityKit

struct MarkItemInBasketIntent: AppIntent {
    init() {}
    
    static var title: LocalizedStringResource = "Mark Item In Basket"
    static var description = IntentDescription("Mark an item as in the basket.")
    
    @Parameter(title: "SimplifiedListItem")
    var simplifiedListItem: String
    
    init(simplifiedListItem: String) {
        self.simplifiedListItem = simplifiedListItem
    }
    
    func perform() async throws -> some IntentResult {
        let listItem = try ListItem.getItemFromItemName(PersistenceController.shared.container.viewContext, itemName: simplifiedListItem)
        ListItem.addMoveToBasketDate(listItem)
        
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
                nextItem = SimplifiedListItem(count: "", name: "No Items Left!", unitAbbrv: nil, categoryName: nil, aisleNumber: "")
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
