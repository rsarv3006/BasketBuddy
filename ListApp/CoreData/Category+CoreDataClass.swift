//
//  Category+CoreDataClass.swift
//  ListApp
//
//  Created by rjs on 12/30/21.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {

    static func addOnLoad() {
        let categoriesStarter = CategoriesStarter()
        let request = Category.fetchRequest()
        let context = PersistenceController.shared.container.viewContext
        do {
            if try context.count(for: request) == 0 {
                for starter in categoriesStarter.categoryNames {
                    let category = Category(context: context)
                    category.name = starter
                }
                try context.save()
            }
        } catch {
            print("Error initializing with Categories")
        }
    }
    
    
}
