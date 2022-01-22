//
//  SettingsCategoriesItem.swift
//  ListApp
//
//  Created by rjs on 1/5/22.
//

import SwiftUI

struct SettingsCategoriesItem: View {
    @Environment(\.colorScheme) var colorScheme
    
    let category: Category
    @EnvironmentObject var selectedStore: SelectedStore
    
    var unSelectedView: some View {
        VStack {
            Text(category.name ?? "")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        // TODO This is a pain in the ass hack because the above ^ doesn't want to apply to just text
        .background(colorScheme == .light ? Color.white : Color(UIColor.systemGray6))
        
    }
    
    var selectedView: some View {
        HStack {
            Image(systemName: "checkmark")
                .foregroundColor(.accentColor)
            unSelectedView
        }
    }
    
    var body: some View {
        if let selectedCat = selectedStore.selectedCategory, selectedCat == category {
            selectedView
        } else {
            unSelectedView
        }
        
        
    }
}

//struct SettingsCategoriesItem_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsCategoriesItem(category: Category())
//    }
//}
