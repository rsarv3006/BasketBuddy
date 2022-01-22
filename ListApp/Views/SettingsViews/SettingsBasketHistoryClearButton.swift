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
            // TODO Fix issue where the section headers don't get removed unless you navigate home and come back
            dateArray = []
            dismiss()
        }, label: {
            Text("Clear")
        })
            .buttonStyle(.bordered)
    }
}

//struct SettingsBasketHistoryClearButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsBasketHistoryClearButton()
//    }
//}
