//
//  ListItem+CoreDataProperties.swift
//  ListApp
//
//  Created by rjs on 1/3/22.
//
//

import Foundation
import CoreData


extension ListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListItem> {
        return NSFetchRequest<ListItem>(entityName: "ListItem")
    }

    @NSManaged public var count: Double
    @NSManaged public var dateAdded: Date?
    @NSManaged public var datesMovedToBasket: [Date]?
    @NSManaged public var name: String?
    @NSManaged public var isVisible: Bool
    @NSManaged public var isStaple: Bool
    @NSManaged public var category: Category?
    @NSManaged public var unit: Unit?

}

extension ListItem : Identifiable {

}
