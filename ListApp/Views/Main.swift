//
//  Main.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI

struct Main: View {    
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
                        }
                        ListComponentBottomToolbar(selectedListItem: $selectedStore.selectedListItem, showAdd: $showAdd)
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

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}


