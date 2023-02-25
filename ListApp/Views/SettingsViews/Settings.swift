//
//  Settings.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI

struct Settings: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isCategoriesViewVisible: Bool = false
    @State var isbasketHistoryViewVisible: Bool = false
    @State var isEditStaplesViewVisible: Bool = false
    @State var isStapleAlertVisible: Bool = false
    @State var isStapleLoadSuccess: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading, spacing: 10) {
                NavigationLink(destination: SettingsCategoriesView(), isActive: $isCategoriesViewVisible) {
                    Button("Categories", action: {
                        isCategoriesViewVisible.toggle()
                    })
                        .buttonStyle(.bordered)
                }
                NavigationLink(destination: SettingsBasketHistoryView(viewContext: viewContext), isActive: $isbasketHistoryViewVisible) {
                    Button("Basket History", action: {
                        isbasketHistoryViewVisible.toggle()
                    })
                        .buttonStyle(.bordered)
                }
                NavigationLink(destination: SettingsEditStaplesView(), isActive: $isEditStaplesViewVisible) {
                    Button("Edit Staples", action: {
                        isEditStaplesViewVisible.toggle()
                    })
                        .buttonStyle(.bordered)
                        .padding(.top)
                }
                Button("Load Staples", action: {
                    isStapleLoadSuccess = ListItem.loadStaples(viewContext)
                    isStapleAlertVisible.toggle()
                })
                    .buttonStyle(.bordered)
                    .alert(isStapleLoadSuccess ? "Loaded Staples successfully." : "Issue encountered loading staples, please try again.", isPresented: $isStapleAlertVisible) {
                        Button("OK", role: .cancel) {}
                    }
            }
            .padding(.leading)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color.theme.linen)
    }
}

//struct Settings_Previews: PreviewProvider {
//    static var previews: some View {
//        Settings()
//    }
//}
