//
//  ItemModel.swift
//  ListApp
//
//  Created by rjs on 1/3/22.
//

import Foundation
import SwiftUI
import CoreData

struct ItemModel {
    func addItem(itemName: String, itemCount: String, unit: Unit, category: Category, isStaple: Bool, viewContext: NSManagedObjectContext) {
        let item = ListItem(context: viewContext)
        item.name = itemName
        item.count = Double(itemCount) ?? 1
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
    
    func editItem(itemToEdit: ListItem, itemName: String, itemCount: String, unit: Unit, category: Category, isStaple: Bool) {
        guard let context = itemToEdit.managedObjectContext else { return }
        
        itemToEdit.name = itemName
        itemToEdit.count = Double(itemCount) ?? 1
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
    
    func deleteItem(_ item: ListItem) {
        guard let context = item.managedObjectContext else { return }
        
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addMoveToBasketDate(_ item: ListItem) {
        guard let context = item.managedObjectContext else { return }
        
        item.isVisible = false
        if var datesMoved = item.datesMovedToBasket {
            datesMoved.append(Date())
            item.datesMovedToBasket = datesMoved
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
}
