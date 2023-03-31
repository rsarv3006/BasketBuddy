//
//  ShareListRow.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 3/30/23.
//

import SwiftUI

struct ShareListRow: View {
    var item: ListItem
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(item.name ?? "")
                            .foregroundColor(Color.Theme.linen)
                        Text("\(String(item.count)) \(item.unit?.abbreviation ?? "")")
                            .foregroundColor(Color.Theme.linen)
                    }
                    .padding(.leading)
                }
                
                Spacer()
                if self.isSelected {
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .foregroundColor(Color.Theme.linen)
                        .padding(.trailing)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color.Theme.seaGreen)
            .cornerRadius(12)
        }
    }
}
