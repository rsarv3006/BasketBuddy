//
//  MarkItemInBasketIntent.swift
//  BasketBuddyWidgetExtension
//
//  Created by Robert J. Sarvis Jr on 11/11/23.
//

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
        return .result()
    }
}
