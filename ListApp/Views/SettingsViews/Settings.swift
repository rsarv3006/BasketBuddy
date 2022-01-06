//
//  Settings.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI

struct Settings: View {
    @State var isCategoriesViewVisible: Bool = false
    @State var isbasketHistoryViewVisible: Bool = false
    @State var isEditStaplesViewVisible: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading, spacing: 10) {
                NavigationLink(destination: SettingsCategoriesView(), isActive: $isCategoriesViewVisible) {
                    Button("Categories", action: {
                        isCategoriesViewVisible.toggle()
                    })
                        .buttonStyle(.bordered)
                }
                NavigationLink(destination: SettingsBasketHistoryView(), isActive: $isbasketHistoryViewVisible) {
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
                Button("Load Staples", action: {})
                    .buttonStyle(.bordered)
            }
            .padding(.leading)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
