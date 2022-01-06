//
//  Unit+CoreDataProperties.swift
//  ListApp
//
//  Created by rjs on 1/3/22.
//
//

import Foundation
import CoreData


extension Unit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Unit> {
        return NSFetchRequest<Unit>(entityName: "Unit")
    }

    @NSManaged public var abbreviation: String?
    @NSManaged public var name: String?

}

extension Unit : Identifiable {

}
