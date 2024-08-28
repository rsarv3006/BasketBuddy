import Bedrock
import CoreData
import Foundation
import WidgetKit

@objc(ListItem)
public class ListItem: NSManagedObject {
    @nonobjc public class func liveActivityUpdate(viewContext _: NSManagedObjectContext) async throws {}

    @nonobjc public class func addItemsFromShareList(viewContext: NSManagedObjectContext, items: Set<ShareListItem>) throws {
        try items.forEach { itemToAdd in
            let unit = Unit.getUnitByName(viewContext: viewContext, name: itemToAdd.unitName)
            let category = CategoryModel.getCategoryByName(viewContext: viewContext, name: itemToAdd.categoryName)

            guard let unit, let category else {
                throw ServiceErrors.custom(message: "Unable to find a matching unit and/or Category")
            }

            self.addItem(itemName: itemToAdd.itemName, itemCount: itemToAdd.itemCount, unit: unit, category: category, isStaple: false, viewContext: viewContext)
        }

        WidgetCenter.shared.reloadTimelines(ofKind: "BasketBuddyWidget")
    }

    @nonobjc public class func addItem(
        itemName: String,
        itemCount: String,
        unit: Unit,
        category: Category,
        isStaple: Bool,
        viewContext: NSManagedObjectContext
    ) {
        let item = ListItem(context: viewContext)
        item.name = itemName
        item.count = itemCount
        item.unit = unit
        item.category = category
        item.dateAdded = Date()
        item.isStaple = isStaple
        item.isVisible = true

        do {
            try viewContext.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "BasketBuddyWidget")
        } catch let error as NSError {
            print("crash on add in itemModel")
            print(error.userInfo)
        }
    }

    @nonobjc public class func editItem(
        itemToEdit: ListItem,
        itemName: String,
        itemCount: String,
        unit: Unit,
        category: Category,
        isStaple: Bool
    ) {
        guard let context = itemToEdit.managedObjectContext else { return }

        itemToEdit.name = itemName
        itemToEdit.count = itemCount
        itemToEdit.unit = unit
        itemToEdit.category = category
        itemToEdit.dateAdded = Date()
        itemToEdit.isStaple = isStaple
        itemToEdit.isVisible = true

        do {
            try context.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "BasketBuddyWidget")
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    @nonobjc public class func deleteItem(_ item: ListItem) {
        guard let context = item.managedObjectContext else { return }

        context.delete(item)

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    @nonobjc public class func makeNotVisible(_ item: ListItem) {
        guard let context = item.managedObjectContext else { return }
        item.isVisible = false

        do {
            try context.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "BasketBuddyWidget")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    @nonobjc public class func addMoveToBasketDate(_ item: ListItem) {
        guard let context = item.managedObjectContext else { return }

        item.isVisible = false
        if var datesMoved = item.datesMovedToBasket {
            datesMoved.append(Date())
            item.datesMovedToBasket = datesMoved
        } else {
            item.datesMovedToBasket = [Date()]
        }

        do {
            try context.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "BasketBuddyWidget")
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    @nonobjc public class func loadStaples(_ context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "isStaple = %@", NSNumber(value: true))

        do {
            let staples = try context.fetch(fetchRequest)
            for item in staples {
                item.isVisible = true
            }

            try context.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "BasketBuddyWidget")
            return true
        } catch let error as NSError {
            print(error.userInfo)
            return false
        }
    }

    @nonobjc public class func makeItemVisible(_ item: ListItem) {
        guard let context = item.managedObjectContext else { return }

        item.isVisible = true

        do {
            try context.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "BasketBuddyWidget")
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    @nonobjc public class func clearAllItems(_ context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isVisible == true")

        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                item.isVisible = false
            }

            try context.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "BasketBuddyWidget")
        } catch {
            print("Failed to clear items: \(error)")
        }
    }

    @nonobjc public class func clearMoveToBasketHistory(_ context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(value: true)

        do {
            let listItems = try context.fetch(fetchRequest)
            for item in listItems {
                if item.datesMovedToBasket != nil {
                    item.datesMovedToBasket = []
                }
            }
            try context.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "BasketBuddyWidget")
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    @nonobjc public class func getSimplifiedListItemsForWidget(_ context: NSManagedObjectContext) throws -> [SimplifiedListItem] {
        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "isVisible = %@", NSNumber(value: true))

        let listItems = try context.fetch(fetchRequest)

        return listItems.map { item in
            SimplifiedListItem(listItem: item)
        }
    }

    @nonobjc public class func getItemFromSimplifiedListItem(_ context: NSManagedObjectContext, simplifiedListItem: SimplifiedListItem) throws -> ListItem {
        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        fetchRequest.sortDescriptors = []
        if let name = simplifiedListItem.name,
           let unit = simplifiedListItem.unitAbbrv,
           let categoryName = simplifiedListItem.categoryName
        {
            fetchRequest.predicate = NSPredicate(format: "name = %@ AND unit = %@ AND category = %@", name, unit, categoryName)

            let listItems = try context.fetch(fetchRequest)

            if listItems.count == 1 {
                return listItems[0]
            } else {
                throw ServiceErrors.custom(message: "Unable to find a matching item")
            }
        } else {
            throw ServiceErrors.custom(message: "Bad simplified list item")
        }
    }

    @nonobjc public class func getItemFromItemName(_ context: NSManagedObjectContext, itemName: String) throws -> ListItem {
        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        fetchRequest.sortDescriptors = []
        if !itemName.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "name = %@ AND isVisible = %@", itemName, NSNumber(value: true))

            let listItems = try context.fetch(fetchRequest)

            if listItems.count == 1 {
                return listItems[0]
            } else {
                throw ServiceErrors.custom(message: "Unable to find a matching item")
            }
        } else {
            throw ServiceErrors.custom(message: "Bad simplified list item")
        }
    }
}
