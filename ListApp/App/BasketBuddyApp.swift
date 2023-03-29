//
//  ListAppApp.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI
import Appodeal

@main
struct BasketBuddyApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var selectedStore = SelectedStore()
    @StateObject var store: Store = Store()
    
    var body: some Scene {
        WindowGroup {
            Main()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(selectedStore)
                .environmentObject(store)
                .onAppear(perform: {
                    Category.addOnLoad(viewContext: persistenceController.container.viewContext)
                    Unit.addOnLoad(viewContext: persistenceController.container.viewContext)

                    Appodeal.setAutocache(false, types: .interstitial)
                    Appodeal.setLogLevel(.error)

                    Appodeal.setTestingEnabled(true)
                    Appodeal.initialize(
                        withApiKey: "",
                        types: [.MREC, .banner]
                    )
                })
        }
    }
}
