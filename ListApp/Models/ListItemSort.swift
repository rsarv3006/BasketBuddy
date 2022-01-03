//
//  ListItemSort.swift
//  ListApp
//
//  Created by rjs on 1/2/22.
//

import Foundation

// TODO: Figure out how to gracefully unwrap the optional cateogry reference

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
            section: \ListItem.category!.name!),
//        FriendSort(
//            id: 2,
//            name: "Meeting Date | Ascending",
//            descriptors: [
//                SortDescriptor(\Friend.meetingDate, order: .forward),
//                SortDescriptor(\Friend.name, order: .forward)
//            ],
//            section: \Friend.meetingDay),
//        FriendSort(
//            id: 3,
//            name: "Meeting Date | Descending",
//            descriptors: [
//                SortDescriptor(\Friend.meetingDate, order: .reverse),
//                SortDescriptor(\Friend.name, order: .forward)
//            ],
//            section: \Friend.meetingDayDescending)
    ]
    
    // 4
    static var `default`: ListItemSort { sorts[0] }
}
