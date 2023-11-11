//
//  Persistence.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application,
            // although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    
    private static func createContainer() -> NSPersistentContainer {
        print("creating container")
        let container = NSPersistentContainer(name: "ListApp")
        let storeURL = AppGroup.basketBuddy.containerURL.appendingPathComponent("ListApp.sqlite")

        print("debug 1")
        var defaultURL: URL?
        if let storeDescription = container.persistentStoreDescriptions.first, let url = storeDescription.url {
            defaultURL = FileManager.default.fileExists(atPath: url.path) ? url : nil
        }
        print("debug 2")
        if defaultURL == nil {
            container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        }
        print("debug 3")
        container.loadPersistentStores(completionHandler: { [unowned container] (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            print("debug 4")
            if let url = defaultURL, url.absoluteString != storeURL.absoluteString {
                let coordinator = container.persistentStoreCoordinator
                if let oldStore = coordinator.persistentStore(for: url) {
                    do {
                        try coordinator.migratePersistentStore(oldStore, to: storeURL, options: nil, withType: NSSQLiteStoreType)
                    } catch {
                        print("HOWDY")
                        print(error.localizedDescription)
                    }

                    // delete old store
                    let fileCoordinator = NSFileCoordinator(filePresenter: nil)
                    fileCoordinator.coordinate(writingItemAt: url, options: .forDeleting, error: nil, byAccessor: { url in
                        do {
                            try FileManager.default.removeItem(at: url)
                        } catch {
                            print("HOWDY 1")
                            print(error.localizedDescription)
                        }
                    })
                }
            }
        })
        print("returning container")
        return container
    }
    
    init(inMemory: Bool = false) {
        
//            container = NSPersistentContainer(name: "ListApp")
        if inMemory {
            container = NSPersistentContainer(name: "ListApp")
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            container = PersistenceController.createContainer()
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
//        container.loadPersistentStores(completionHandler: { (_, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate.
//                // You should not use this function in a shipping application,
//                // although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible,
//                 due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
    }
}
