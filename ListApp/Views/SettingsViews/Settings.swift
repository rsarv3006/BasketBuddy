//
//  Settings.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI
import StoreKit

struct Settings: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var store: Store
    
    @State var isCategoriesViewVisible: Bool = false
    @State var isbasketHistoryViewVisible: Bool = false
    @State var isEditStaplesViewVisible: Bool = false
    @State var isStapleAlertVisible: Bool = false
    @State var isStapleLoadSuccess: Bool = false
    @State var isLegalViewVisible: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                
                NavigationLink(destination: SettingsCategoriesView(), isActive: $isCategoriesViewVisible) {
                    Button("Categories", action: {
                        isCategoriesViewVisible.toggle()
                    })
                    .buttonStyle(.bordered)
                }
                NavigationLink(
                    destination: SettingsBasketHistoryView(viewContext: viewContext),
                    isActive: $isbasketHistoryViewVisible) {
                        Button("Basket History", action: {
                            isbasketHistoryViewVisible.toggle()
                        })
                        .buttonStyle(.bordered)
                    }
                NavigationLink(destination: SettingsEditStaplesView(), isActive: $isEditStaplesViewVisible) {
                    Button("Edit Pantry Staples", action: {
                        isEditStaplesViewVisible.toggle()
                    })
                    .buttonStyle(.bordered)
                    .padding(.top)
                }
                
                Button("Load Pantry Staples", action: {
                    isStapleLoadSuccess = ListItem.loadStaples(viewContext)
                    isStapleAlertVisible.toggle()
                })
                .buttonStyle(.bordered)
                .alert(isStapleLoadSuccess
                       ? "Loaded Staples successfully."
                       : "Issue encountered loading staples, please try again.", isPresented: $isStapleAlertVisible) {
                    Button("OK", role: .cancel) {}
                }
                .padding(.bottom)
                
                SettingsViewShareButtons()
                
                ContactSupport()
                
                NavigationLink(destination: SettingsLegalView(), isActive: $isLegalViewVisible) {
                    Button("Legal Information", action: {
                        isLegalViewVisible.toggle()
                    })
                    .buttonStyle(.bordered)
                }
                
                if let product = store.smallTipInAppPurchase {
                    SettingsInAppPurchases(product: product)
                        .padding(.top)
                }

                AppVersionView()

                HStack {
                    Spacer()
                }
                
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
    }
}
