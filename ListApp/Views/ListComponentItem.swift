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
                .foregroundColor(Color.Theme.linen)
            Text("\(String(item.count)) \(item.unit?.abbreviation ?? "")")
                .foregroundColor(Color.Theme.linen)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.Theme.seaGreen)

    }

    var selectedView: some View {
        HStack {
            Image(systemName: "checkmark")
                .foregroundColor(Color.Theme.redMunsell)
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
