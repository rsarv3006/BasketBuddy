//
//  Main.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI

struct Main: View {
    @Environment(\.presentationMode) var presentation
    @State private var showSettings = false
    @State private var showAdd = false
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var selectedStore: SelectedStore
    
    var body: some View {
        NavigationView {
            ZStack {
                ListComponent()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showSettings.toggle()
                            } label: {
                                Image(systemName: "gearshape")
                            }
                            .frame(height: 96, alignment: .trailing) // Workaroud, credit: https://stackoverflow.com/a/62209223/5421557
                        }
                        ListComponentBottomToolbar(selectedListItem: $selectedStore.selectedListItem, centerImageName: selectedStore.selectedListItem == nil ? "plus" : "cart.badge.plus", leftButtonOnPress: {showAdd.toggle()}, middleButtonOnPress: {
                            if (selectedStore.selectedListItem == nil) {
                                showAdd.toggle()
                            } else if let item = selectedStore.selectedListItem {
                                ListItem.addMoveToBasketDate(item)
                                selectedStore.selectedListItem = nil
                            }
                        }, middleButtonOnSwipe: { value in
                            if value.translation.height < 0 && selectedStore.selectedListItem == nil {
                                showAdd.toggle()
                            }
                        }, rightButtonOnPress: {
                            if let safeSelectedItem = selectedStore.selectedListItem {
                                ListItem.makeNotVisible(safeSelectedItem)
                                selectedStore.selectedListItem = nil
                            }})
                    }
                NavigationLink(destination: Settings(), isActive: $showSettings) {
                    EmptyView()
                }
            }
            .sheet(isPresented: $showAdd) {
                AddItems(viewContext: viewContext, selectedItem: $selectedStore.selectedListItem)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    
}

//struct Main_Previews: PreviewProvider {
//    static var previews: some View {
//        Main()
//    }
//}


