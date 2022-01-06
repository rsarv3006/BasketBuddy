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
                Section(header: Text(section.id)) {
                    ForEach(section) { item in
                        ListComponentItem(item: item)
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
        .frame(maxWidth: .infinity)
        
        
        
    }
}

struct ListComponent_Previews: PreviewProvider {
    static var previews: some View {
        ListComponent()
    }
}
