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

    static func addOnLoad(viewContext: NSManagedObjectContext) {
        let categoriesStarter = CategoriesStarter()
        let request = Category.fetchRequest()

        do {
            if try viewContext.count(for: request) == 0 {
                for starter in categoriesStarter.categoryNames {
                    let category = Category(context: viewContext)
                    category.name = starter
                }
                try viewContext.save()
            }
        } catch {
            print("Error initializing with Categories")
        }
    }
}
