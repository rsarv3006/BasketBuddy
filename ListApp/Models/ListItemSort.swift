//
//  ListItemSort.swift
//  ListApp
//
//  Created by rjs on 1/2/22.
//

import Foundation

struct ListItemSort: Hashable, Identifiable {
    let id: Int
    let name: String
    let descriptors: [SortDescriptor<ListItem>]
    let section: KeyPath<ListItem, String>

    static let sorts: [ListItemSort] = [
        ListItemSort(
            id: 0,
            name: "Category | Ascending",
            descriptors: [
                SortDescriptor(\ListItem.category?.name, order: .forward),
                SortDescriptor(\ListItem.category?.name, order: .forward)
            ],
            section: \ListItem.category!.name!),
        ListItemSort(
            id: 1,
            name: "Category | Descending",
            descriptors: [
                SortDescriptor(\ListItem.category?.name, order: .reverse),
                SortDescriptor(\ListItem.category?.name, order: .forward)
            ],
            section: \ListItem.category!.name!)
    ]

    static var `default`: ListItemSort { sorts[0] }
}
