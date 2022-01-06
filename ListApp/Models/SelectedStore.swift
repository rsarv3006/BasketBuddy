//
//  SelectedItemsStore.swift
//  ListApp
//
//  Created by rjs on 1/4/22.
//

import Foundation
class SelectedStore: ObservableObject {
    @Published var selectedListItem: ListItem? = nil
    @Published var selectedCategory: Category? = nil
    
    init() {}
}
