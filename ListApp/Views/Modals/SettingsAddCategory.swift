//
//  SettingsAddCategory.swift
//  ListApp
//
//  Created by rjs on 1/5/22.
//

import SwiftUI
import CoreData
import GoogleMobileAds

struct SettingsAddCategory: View {
    @Environment(\.presentationMode) var presentationMode
    var viewContext: NSManagedObjectContext
    
    @State var categoryName = ""
    @State var nameError: Bool = false
    let categoryModel = CategoryModel()
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center, spacing: 10) {
                Text("Add a Category")
                    .foregroundColor(Color.theme.seaGreen)
                    .padding(EdgeInsets(top: reader.size.height * 0.1, leading: 0, bottom: 0, trailing: 0))
                TextField("Category Name", text: $categoryName)
                    .textFieldStyle(TextFieldDefaultBackgroundSeagreenBorder())
                    .frame(width: reader.size.width * 0.8, alignment: .center)
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
                
                Spacer()
                GADLargeRectangleBannerViewController()
                    .frame(width: GADAdSizeMediumRectangle.size.width, height: GADAdSizeMediumRectangle.size.height, alignment: .center)
                
            }
            .frame(width: reader.size.width, alignment: .center)
        }
        .background(Color.theme.linen)
    }
}
