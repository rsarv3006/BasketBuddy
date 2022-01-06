//
//  BottomToolbar.swift
//  ListApp
//
//  Created by rjs on 1/3/22.
//

import SwiftUI

struct ListComponentBottomToolbar: ToolbarContent {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedListItem: ListItem?
    
    @Binding var showAdd: Bool
    
    let itemModel = ItemModel()
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            if (selectedListItem != nil) {
                Button {
                    showAdd.toggle()
                } label: {
                    Image(systemName: "pencil.circle")
                        .font(.system(size: 30))
                }
                Spacer()
            }
            BottomCenterButton(centerImageName: selectedListItem == nil ? "plus" : "cart.badge.plus", onPressed: {
                if (selectedListItem == nil) {
                    showAdd.toggle()
                } else if let item = selectedListItem {
                    itemModel.addMoveToBasketDate(item)
                    selectedListItem = nil
                }
            })
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded({ value in
                    if value.translation.height < 0 && selectedListItem == nil {
                        showAdd.toggle()
                    }
                })
                )
            if (selectedListItem !== nil) {
                Spacer()
                Button {
                    if let safeSelectedItem = selectedListItem {
                        itemModel.deleteItem(safeSelectedItem)
                        selectedListItem = nil
                    }
                } label: {
                    Image(systemName: "trash.circle")
                        .font(.system(size: 30))
                }
            }
        }
    }
}
