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
        ZStack {
            List {
                ForEach(categories) { category in
                    if let safeCat = category {
                        SettingsCategoriesItem(category: safeCat)
                            .listRowBackground(Color.theme.seaGreen)
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
            if categories.isEmpty {
                Spacer()
                    .background(Color.theme.linen)
            }
        }
        .background(Color.theme.linen)
        .scrollContentBackground(.hidden)
        .toolbar {
            SettingsCategoriesBottomToolbar(selectedCategory: $selectedStore.selectedCategory, showAdd: $showAdd, isDeleteAlertVisible: $isDeleteAlertVisible)
        }
        .sheet(isPresented: $showAdd) {
            SettingsAddCategory(viewContext: viewContext)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Categories")
                        .font(.headline)
                        .foregroundColor(Color.theme.seaGreen)
                }
            }
        }
    }
}

struct SettingsCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCategoriesView()
    }
}
