//
//  ItemsToBeAddedView.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 4/11/23.
//

import SwiftUI

struct ItemsToBeAddedView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var itemsToBeAdded: [ShareListItem]
    
    @State private var selectedItems: Set<ShareListItem> = []
    @State private var didErrorAddingItems: Bool = false
    @State private var errorAddingItems: String = ""
    @State private var didAddItems: Bool = false
    
    
    var body: some View {
        VStack {
            ZStack {
                List {
                    ForEach(itemsToBeAdded) { item in
                        ItemToBeAddedRow(item: item, isSelected: self.selectedItems.contains(item)) {
                            if self.selectedItems.contains(item) {
                                self.selectedItems.remove(item)
                            } else {
                                self.selectedItems.insert(item)
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .background(Color.Theme.linen)
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity)
                
                if itemsToBeAdded.isEmpty {
                    Spacer().background(Color.Theme.linen)
                }
            }
            
            Button("Add Selected Items") {
                do {
                    let categoriesToBeCreated = CategoryModel.categoriesToBeCreatedFromShareListArray(viewContext: viewContext, shareListArray: selectedItems)
                    
                    try CategoryModel.createCategories(viewContext: viewContext, fromArray: categoriesToBeCreated)
                    
                    try ListItem.addItemsFromShareList(viewContext: viewContext, items: selectedItems)
                    
                    didAddItems = true
                } catch {
                    errorAddingItems = error.localizedDescription
                    didErrorAddingItems = true
                }
                
            }
            .buttonStyle(.bordered)
        }
        .background(Color.Theme.linen)
        .onAppear {
            for item in itemsToBeAdded {
                selectedItems.insert(item)
            }
        }
        .alert("Error Importing Items \n \(errorAddingItems)", isPresented: $didErrorAddingItems) {
            Button("Ok", role: .cancel) {}
        }
        .alert("Items added successfully", isPresented: $didAddItems) {
            Button("Ok", role: .cancel) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ItemsToBeAddedView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsToBeAddedView(itemsToBeAdded: .constant([
            ShareListItem(itemName: "Test Item", itemCount: "1", unitName: "Pounds", unitAbbreviation: "lb", categoryName: "Bakery"),
            ShareListItem(itemName: "Test Item", itemCount: "1", unitName: "Pounds", unitAbbreviation: "lb", categoryName: "Bakery"),
            ShareListItem(itemName: "Test Item", itemCount: "1", unitName: "Pounds", unitAbbreviation: "lb", categoryName: "Bakery")
        ]))
    }
}
