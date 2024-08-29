import SwiftUI

@main
struct BasketBuddyApp: App {
    @State var deeplinkTarget: DeeplinkManager.DeeplinkTarget?
    
    let persistenceController = PersistenceController.shared
    @StateObject private var selectedStore = SelectedStore()
    @StateObject var store: Store = Store()
    @StateObject private var liveActivityViewModel = StartLiveActivityViewModel(viewContext: PersistenceController.shared.container.viewContext)
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch self.deeplinkTarget {
                case .home:
                    Main()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(selectedStore)
                        .environmentObject(store)
                        .environmentObject(liveActivityViewModel)
                        .onAppear(perform: {
                            Category.addOnLoad(viewContext: persistenceController.container.viewContext)
                            Unit.addOnLoad(viewContext: persistenceController.container.viewContext)
                        })
                        .checkAppVersion()
                case .share(let shareCode):
                    NavigationView {
                        ImportShareListView(shareCodeId: shareCode, deeplinkTarget: $deeplinkTarget)
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .environmentObject(selectedStore)
                            .environmentObject(store)
                            .environmentObject(liveActivityViewModel)
                            .onAppear(perform: {
                                Category.addOnLoad(viewContext: persistenceController.container.viewContext)
                                Unit.addOnLoad(viewContext: persistenceController.container.viewContext)
                            })
                            .checkAppVersion()
                    }
                case .none:
                    Main()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(selectedStore)
                        .environmentObject(store)
                        .environmentObject(liveActivityViewModel)
                        .onAppear(perform: {
                            Category.addOnLoad(viewContext: persistenceController.container.viewContext)
                            Unit.addOnLoad(viewContext: persistenceController.container.viewContext)
                        })
                        .checkAppVersion()
                }
                
            }
            .onOpenURL(perform: { url in
                let deeplinkManager = DeeplinkManager()
                let deeplink = deeplinkManager.manage(url: url)
                self.deeplinkTarget = deeplink
            })
        }
    }
}
