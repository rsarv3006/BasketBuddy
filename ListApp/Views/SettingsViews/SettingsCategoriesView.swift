//
//  SettingsCategoriesView.swift
//  ListApp
//
//  Created by rjs on 1/5/22.
//

import SwiftUI

struct SettingsCategoriesView: View {
    @EnvironmentObject var selectedStore: SelectedStore
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: false)], animation: .default)
    private var categories: FetchedResults<Category>
    
    @State var showAdd: Bool = false
    @State var isDeleteAlertVisible = false
    
    var body: some View {
        List {
            ForEach(categories) { category in
                if let safeCat = category {
                    SettingsCategoriesItem(category: safeCat)
                        .onTapGesture {
                            if selectedStore.selectedCategory == category {
                                selectedStore.selectedCategory = nil
                            } else {
                                selectedStore.selectedCategory = category
                            }
                            
                        }
                }
            }
        }
        .toolbar {
            SettingsCategoriesBottomToolbar(selectedCategory: $selectedStore.selectedCategory, showAdd: $showAdd, isDeleteAlertVisible: $isDeleteAlertVisible)
        }
        .sheet(isPresented: $showAdd) {
            SettingsAddCategory(viewContext: viewContext)
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCategoriesView()
    }
}
