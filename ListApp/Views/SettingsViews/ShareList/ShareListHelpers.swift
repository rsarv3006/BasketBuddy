//
//  ShareListHelpers.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 3/30/23.
//

import SwiftUI

func buildItemsDisplayString(_ items: Set<ListItem>) -> String {
    var returnString = ""
    items.forEach { item in
        if let itemName = item.name {
            
            var abbrString = ""
            if let itemAbbr = item.unit?.abbreviation, !itemAbbr.isEmpty {
                abbrString = " \(itemAbbr)"
            }

            returnString += "\(itemName) - \(item.count)\(abbrString),\n"
        }
    }
    
    return returnString
}

func areAllItemsSelected(_ items: SectionedFetchResults<String, ListItem>, _ selectedItems: Set<ListItem>) -> Bool {
    return items.count > 0 && selectedItems.count == items.count
}
