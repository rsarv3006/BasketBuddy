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
    
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            if (selectedListItem != nil) {
                Button(action: leftButtonOnPress, label: {
                    Image(systemName: "pencil.circle")
                        .font(.system(size: 30))
                })
                Spacer()
            }
            BottomCenterButton(centerImageName: centerImageName, onPressed: middleButtonOnPress)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded(middleButtonOnSwipe)
                )
            if (selectedListItem !== nil) {
                Spacer()
                Button(action: rightButtonOnPress, label: {
                    Image(systemName: "trash.circle")
                        .font(.system(size: 30))
                })
            }
        }
    }
}
