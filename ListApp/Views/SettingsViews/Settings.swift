//
//  Settings.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI
import GoogleMobileAds

struct Settings: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isCategoriesViewVisible: Bool = false
    @State var isbasketHistoryViewVisible: Bool = false
    @State var isEditStaplesViewVisible: Bool = false
    @State var isStapleAlertVisible: Bool = false
    @State var isStapleLoadSuccess: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
            
            Spacer()
            GADLargeRectangleBannerViewController()
                .frame(width: GADAdSizeMediumRectangle.size.width, height: GADAdSizeMediumRectangle.size.height, alignment: .center)
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
