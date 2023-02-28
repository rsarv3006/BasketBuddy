//
//  ListComponent.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI

struct ListComponent: View {    
    @EnvironmentObject var selectedStore: SelectedStore
    
    private var listItems: SectionedFetchResults<String, ListItem>
    init(listItems: SectionedFetchResults<String, ListItem>) {
        self.listItems = listItems
    }
    
    var body: some View {
        List {
            ForEach(listItems) { section in
                Section(header: Text(section.id).foregroundColor(Color.theme.seaGreen)) {
                    ForEach(section) { item in
                        ListComponentItem(item: item, selectedItem: $selectedStore.selectedListItem)
                            .listRowBackground(Color.theme.seaGreen)
                            .onTapGesture {
                                if selectedStore.selectedListItem == item {
                                    selectedStore.selectedListItem = nil
                                } else {
                                    selectedStore.selectedListItem = item
                                }

                            }
                    }
                }
                
            }
        }
        .background(Color.theme.linen)
        .scrollContentBackground(.hidden)
        .frame(maxWidth: .infinity)
    }
}

//struct ListComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ListComponent()
//    }
//}
