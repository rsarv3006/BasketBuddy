//
//  ListItem+CoreDataProperties.swift
//  ListApp
//
//  Created by rjs on 12/30/21.
//
//

import Foundation
import CoreData


extension ListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListItem> {
        return NSFetchRequest<ListItem>(entityName: "ListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var count: Double
    @NSManaged public var category: Category?
    @NSManaged public var unit: Unit?

}

extension ListItem : Identifiable {

}
