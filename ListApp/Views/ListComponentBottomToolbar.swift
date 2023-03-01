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
    var centerImageName: String
    var leftButtonOnPress: () -> Void
    var middleButtonOnPress: () -> Void
    var middleButtonOnSwipe: (_: DragGesture.Value) -> Void
    var rightButtonOnPress: () -> Void

    // Note to self, using ToolbarItem(s) here because the ToolbarGroup has a weird alignment bug coming into and out of a modal, #JustSwiftUIThings
    var body: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            if selectedListItem != nil {
                Button(action: leftButtonOnPress, label: {
                    Image(systemName: "pencil.circle")
                        .font(.system(size: 30))
                        .foregroundColor(Color.Theme.seaGreen)
                })
            }
        }
        ToolbarItem(placement: .bottomBar, content: {Spacer()})
        ToolbarItem(placement: .bottomBar) {
            BottomCenterButton(centerImageName: centerImageName, onPressed: middleButtonOnPress)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded(middleButtonOnSwipe)
                )
        }
        ToolbarItem(placement: .bottomBar, content: {Spacer()})
        ToolbarItem(placement: .bottomBar) {
            if selectedListItem !== nil {
                Button(action: rightButtonOnPress, label: {
                    Image(systemName: "trash.circle")
                        .font(.system(size: 30))
                        .foregroundColor(Color.Theme.redMunsell)
                })
            }
        }
    }
}
