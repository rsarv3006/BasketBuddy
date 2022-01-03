//
//  ListComponent.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI

struct ListComponent: View {
    @SectionedFetchRequest(sectionIdentifier: ListItemSort.default.section, sortDescriptors: ListItemSort.default.descriptors, animation: .default)
    private var listItems: SectionedFetchResults<String, ListItem>
    
    @State var selectedItem: ListItem?
    
    var body: some View {
        List {
            ForEach(listItems) { section in
                Section(header: Text(section.id)) {
                    ForEach(section) { item in
                        ListComponentItem(item: item, selectedItem: $selectedItem)
                            .onTapGesture {
                                if selectedItem == item {
                                    selectedItem = nil
                                } else {
                                    selectedItem = item
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
