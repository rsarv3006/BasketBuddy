//
//  SettingsCategoriesBottomToolbar.swift
//  ListApp
//
//  Created by rjs on 1/5/22.
//

import SwiftUI

struct SettingsCategoriesBottomToolbar: ToolbarContent {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedCategory: Category?
    
    @Binding var showAdd: Bool
    
    let categoryModel = CategoryModel()
    
    @Binding var isDeleteAlertVisible: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            if (selectedCategory != nil) {
                EmptyView()
                Spacer()
            }
            BottomCenterButton(centerImageName: "plus", onPressed: {
                showAdd.toggle()
            })
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded({ value in
                    if value.translation.height < 0 && selectedCategory == nil {
                        showAdd.toggle()
                    }
                })
                )
            if (selectedCategory !== nil) {
                Spacer()
                Button {
                    print("Delete requested 39")
                    isDeleteAlertVisible.toggle()
                } label: {
                    Image(systemName: "trash.circle")
                        .font(.system(size: 30))
                        .foregroundColor(Color.theme.redMunsell)
                }
                .alert("Are you sure you want to delete this Category? Doing so will remove all items of this Category as well.", isPresented: $isDeleteAlertVisible) {
                    Button("Cancel", role: .cancel) {}
                    Button("Ok", role: .destructive) {
                        if let safeCategory = selectedCategory {
                            categoryModel.delete(safeCategory)
                            selectedCategory = nil
                        }
                    }
                }
                Spacer()
            }
        }
    }
}
