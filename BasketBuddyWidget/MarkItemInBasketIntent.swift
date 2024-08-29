import AppIntents
import CoreData

struct MarkItemInBasketIntent: AppIntent {
    init() {}
    
    static var title: LocalizedStringResource = "Mark Item In Basket"
    static var description = IntentDescription("Mark an item as in the basket.")
    
    static let persistenceController = PersistenceController.shared
    let managedObjectContext = PersistenceController.shared.container.viewContext

    @Parameter(title: "SimplifiedListItem")
    var simplifiedListItem: String
    
    init(simplifiedListItem: String) {
        self.simplifiedListItem = simplifiedListItem
    }
    
    func perform() async throws -> some IntentResult {
        let listItem = try ListItem.getItemFromItemName(managedObjectContext, itemName: simplifiedListItem)
        ListItem.addMoveToBasketDate(listItem)
        
        let sharedDefaults = UserDefaults(suiteName: "group.rjs.app.dev.basketbuddy")
        sharedDefaults?.set(true, forKey: kCoreDataChangedKey)
        sharedDefaults?.synchronize()
        
        return .result()
    }
}
