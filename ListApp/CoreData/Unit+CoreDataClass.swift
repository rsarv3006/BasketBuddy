//
//  Unit+CoreDataClass.swift
//  ListApp
//
//  Created by rjs on 12/30/21.
//
//

import Foundation
import CoreData

@objc(Unit)
public class Unit: NSManagedObject {

    static func addOnLoad() {
        let unitsStarter = UnitsStarter()
        let request = Unit.fetchRequest()
        let context = PersistenceController.shared.container.viewContext
        
        do {
            if try context.count(for: request) == 0 {
                for starter in unitsStarter.unitNames {
                    let unit = Unit(context: context)
                    unit.name = starter
                    unit.abbreviation = unitsStarter.abbrevDict[starter]
                }
                try context.save()
            }
        } catch {
            print("Error initialiZing with Units")
        }
    }
}
