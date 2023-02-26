//
//  CategoryModel.swift
//  ListApp
//
//  Created by rjs on 1/5/22.
//

import SwiftUI
import CoreData

struct CategoryModel {
    func add(name: String, viewContext: NSManagedObjectContext) {
        let category = Category(context: viewContext)
        category.name = name
        
        do {
            try viewContext.save()
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func delete(_ category: Category) {
        print("Howdy")
        guard let context = category.managedObjectContext else { return }
        
        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "category = %@", category)
        
        do {
            let listItems = try context.fetch(fetchRequest)
            for item in listItems {
                context.delete(item)
            }
            context.delete(category)
            try context.save()
        } catch {
            print("Caught thrown error")
            print(error.localizedDescription)
        }
    }
}
