//
//  Category+CoreDataProperties.swift
//  ListApp
//
//  Created by rjs on 1/3/22.
//
//

import Foundation
import CoreData

extension Category {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
    @NSManaged public var name: String?
}

extension Category: Identifiable {}
