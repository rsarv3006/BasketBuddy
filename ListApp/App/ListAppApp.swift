//
//  ListAppApp.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI

@main
struct ListAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Main()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear(perform: {
                    Category.addOnLoad()
                    Unit.addOnLoad()
                })
        }
    }
    
}
