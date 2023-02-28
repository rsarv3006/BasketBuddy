//
//  ListAppApp.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI
import GoogleMobileAds

@main
struct ListAppApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var selectedStore = SelectedStore()
    
    var body: some Scene {
        WindowGroup {
            Main()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(selectedStore)
                .onAppear(perform: {
                    Category.addOnLoad(viewContext: persistenceController.container.viewContext)
                    Unit.addOnLoad(viewContext: persistenceController.container.viewContext)
                    
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                })
        }
    }
    
}
