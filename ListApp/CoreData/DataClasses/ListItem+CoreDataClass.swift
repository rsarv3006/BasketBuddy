//
//  ListItem+CoreDataClass.swift
//  ListApp
//
//  Created by rjs on 12/30/21.
//
//

import Foundation
import CoreData

@objc(ListItem)
public class ListItem: NSManagedObject {
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
        } catch let error as NSError {
            print(error.userInfo)
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
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
}
