//
//  SettingsAddCategory.swift
//  ListApp
//
//  Created by rjs on 1/5/22.
//

import SwiftUI
import CoreData

struct SettingsAddCategory: View {
    @Environment(\.presentationMode) var presentationMode
    var viewContext: NSManagedObjectContext
    
    @State var categoryName = ""
    @State var nameError: Bool = false
    let categoryModel = CategoryModel()
    
    var body: some View {
        TextField("Category Name", text: $categoryName)
        if nameError {
            Text("Category Name is required")
                .foregroundColor(.red)
        }
        Button {
            if categoryName.isEmpty {
                nameError = categoryName.isEmpty
            } else {
                nameError = categoryName.isEmpty
                categoryModel.add(name: categoryName, viewContext: viewContext)
                presentationMode.wrappedValue.dismiss()
            }

        } label: {
            Text("Add")
        }
            .buttonStyle(.borderedProminent)
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
        .buttonStyle(.bordered)
    }
}
