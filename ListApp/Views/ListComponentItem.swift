//
//  ListComponentItem.swift
//  ListApp
//
//  Created by rjs on 1/2/22.
//

import SwiftUI

struct ListComponentItem: View {
    @Environment(\.colorScheme) var colorScheme
    
    let item: ListItem
    @Binding var selectedItem: ListItem?
    
    var unSelectedView: some View {
        VStack(alignment: .leading) {
            Text(item.name ?? "")
            Text("\(String(item.count)) \(item.unit?.abbreviation ?? "")")
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        // TODO This is a pain in the ass hack because the above ^ doesn't want to apply to just text
        .background(colorScheme == .light ? Color.white : Color(UIColor.systemGray6) )
        
    }
    
    var selectedView: some View {
        HStack {
            Image(systemName: "checkmark")
                .foregroundColor(.accentColor)
            unSelectedView
        }
    }
    
    var body: some View {
        if let selectedItem = selectedItem, selectedItem == item {
            selectedView
        } else {
            unSelectedView
        }
    }
}

//struct ListComponentItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ListComponentItem(item: ListItem(), selectedItem: .constant(ListItem()))
//    }
//}
