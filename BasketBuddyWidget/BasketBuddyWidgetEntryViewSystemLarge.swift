//
//  BasketBuddyWidgetEntryViewSystemMedium.swift
//  BasketBuddyWidgetExtension
//
//  Created by Robert J. Sarvis Jr on 11/11/23.
//

import SwiftUI

struct BasketBuddyWidgetEntryViewSystemLarge: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("BasketBuddy")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 2)
                .foregroundStyle(.seaGreen)
            
            if entry.listItems.isEmpty {
                Text("0 Items")
                    .foregroundStyle(.seaGreen)
                    .font(.subheadline)
            }
            
            ForEach(entry.listItems, id: \.self) { item in
                Button(intent: MarkItemInBasketIntent(simplifiedListItem: item.name ?? "")) {
                    HStack {
                        Circle()
                            .strokeBorder(.seaGreen, lineWidth: 1.5)
                            .frame(width: 12, height: 12)
                            .padding(.trailing, -4)
                        Text(parseItemForMediumSystemItemText(item: item))
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(.subheadline)
                            .foregroundStyle(.seaGreen)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
