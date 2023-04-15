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

    static func addOnLoad(viewContext: NSManagedObjectContext) {
        let unitsStarter = UnitsStarter()
        let request = Unit.fetchRequest()

        do {
            if try viewContext.count(for: request) == 0 {
                for starter in unitsStarter.unitNames {
                    let unit = Unit(context: viewContext)
                    unit.name = starter
                    unit.abbreviation = unitsStarter.abbrevDict[starter] ?? ""
                }
                try viewContext.save()
            }
        } catch {
            print("Error initialiZing with Units")
        }
    }
    
    static func getUnitByName(viewContext: NSManagedObjectContext, name: String) -> Unit? {
        let request = Unit.fetchRequest() as NSFetchRequest<Unit>
        request.predicate = NSPredicate(format: "name == %@", name)
        do {
            let unit = try viewContext.fetch(request)
            return unit.first
        } catch {
            print("Error fetching unit by name")
            return nil
        }
    }
}
