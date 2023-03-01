//
//  SettingsBasketHistoryClearButton.swift
//  ListApp
//
//  Created by rjs on 1/8/22.
//

import SwiftUI

struct SettingsBasketHistoryClearButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss

    @Binding var dateArray: [String]

    var body: some View {
        Button(action: {
            ListItem.clearMoveToBasketHistory(viewContext)
            dateArray = []
        }, label: {
            Text("Clear")
        })
        .buttonStyle(.bordered)
    }
}
