import StoreKit
import SwiftUI
import Bedrock

struct Settings: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var store: Store
    
    @State var isStapleAlertVisible: Bool = false
    @State var isStapleLoadSuccess: Bool = false
    @State var shouldShowClearBasketConfirmModal = false
    @State var didClearBasketSuccessfully = false
    @State var isLiveActivityEnabled = false

    var body: some View {
        VStack {
            ScrollView {
                NavigationLink("Categories", destination: SettingsCategoriesView())
                    .buttonStyle(.bordered)

                NavigationLink("Basket History", destination: SettingsBasketHistoryView(viewContext: viewContext))
                    .buttonStyle(.bordered)

                NavigationLink("Edit Pantry Staples", destination: SettingsEditStaplesView())
                    .buttonStyle(.bordered)
                    .padding(.top)

                Button("Load Pantry Staples", action: {
                    viewContext.refreshAllObjects()
                    isStapleLoadSuccess = ListItem.loadStaples(viewContext)
                    isStapleAlertVisible.toggle()
                })
                .buttonStyle(.bordered)
                .alert(isStapleLoadSuccess
                    ? "Loaded Staples successfully."
                    : "Issue encountered loading staples, please try again.", isPresented: $isStapleAlertVisible)
                {
                    Button("OK", role: .cancel) {}
                }
                .padding(.bottom)
                
                Button("Clear Basket") {
                    shouldShowClearBasketConfirmModal = true
                }
                .buttonStyle(.bordered)
                .alert("Are you sure you want to clear all items from your list?", isPresented: $shouldShowClearBasketConfirmModal) {
                    Button("No") {
                        shouldShowClearBasketConfirmModal = false
                    }
                    
                    Button("Yes") {
                        shouldShowClearBasketConfirmModal = false
                        ListItem.clearAllItems(viewContext)
                        didClearBasketSuccessfully = true
                    }
                }
                .alert("List cleared!", isPresented: $didClearBasketSuccessfully) {
                    Button("Ok") {
                        didClearBasketSuccessfully = false
                    }
                }
                .padding(.bottom)

                SettingsViewShareButtons()

                ContactSupport()

                NavigationLink("Legal Information", destination: SettingsLegalView())
                    .buttonStyle(.bordered)

                if let product = store.smallTipInAppPurchase {
                    SettingsInAppPurchases(product: product)
                        .padding(.top)
                }
              
                
                if isLiveActivityEnabled {
                    StartLiveActivityView()
                        .padding(.top)
                }

                AppVersionView()
                
                HStack {
                    Spacer()
                }
            }

            HStack {
                Spacer()

                Button {
                    if let url = URL(string: "https://shiner.rjs-app-dev.us/") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Image(systemName: "pawprint.circle")
                }
                .padding(.horizontal)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Settings")
                        .font(.headline)
                        .foregroundColor(Color.Theme.seaGreen)
                }
            }
        }
        .background(Color.Theme.linen)
        .onAppear {
            checkIfLiveActivityIsEnabled()
        }
    }
    
    func checkIfLiveActivityIsEnabled() {
        Task {
            if let config = await ConfigService.shared.getConfig(), let isLiveActivityEnabled = config.isLiveActivityEnabled {
                self.isLiveActivityEnabled = isLiveActivityEnabled
            }
        }
    }
}
