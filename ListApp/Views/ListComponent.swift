//
//  ListComponent.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI

struct ListComponent: View {
    @SectionedFetchRequest(sectionIdentifier: ListItemSort.default.section, sortDescriptors: ListItemSort.default.descriptors, predicate: NSPredicate(format: "isVisible = %@", NSNumber(value: true)) ,animation: .default)
    private var listItems: SectionedFetchResults<String, ListItem>
    
    @EnvironmentObject var selectedStore: SelectedStore
    
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
