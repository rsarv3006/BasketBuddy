//
//  ListComponentItem.swift
//  ListApp
//
//  Created by rjs on 1/2/22.
//

import SwiftUI

struct ListComponentItem: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var selectedStore: SelectedStore
    
    let item: ListItem
    @Binding var selectedItem: ListItem?
    var onTapGesture: () -> Void
    var selectedImageName: String = "checkmark"
    
    var unSelectedView: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(item.name ?? "")
                    .foregroundColor(Color.Theme.linen)
                Text("\(String(item.count)) \(item.unit?.abbreviation ?? "")")
                    .foregroundColor(Color.Theme.linen)
            }
            .padding(.leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.Theme.seaGreen)
        .cornerRadius(12)
        
    }

    var selectedView: some View {
        HStack {
            unSelectedView
            ZStack {
                Image(systemName: selectedImageName)
                    .foregroundColor(Color.Theme.seaGreen)
                    .fontWeight(.heavy)
                    .font(.largeTitle)
            }
            .onTapGesture(perform: onTapGesture)
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
