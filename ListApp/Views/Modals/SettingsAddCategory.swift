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
    @EnvironmentObject var store: Store
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    @State var categoryName = ""
    @State var nameError: Bool = false
    @State private var didErrorCreatingCategory = false
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center, spacing: 10) {
                Text("Add a Category")
                    .foregroundColor(Color.Theme.seaGreen)
                    .padding(EdgeInsets(top: reader.size.height * 0.1, leading: 0, bottom: 0, trailing: 0))
                
                TextField("Category Name", text: $categoryName)
                    .foregroundColor(Color.Theme.seaGreen)
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
                        do {
                            _ = try CategoryModel.add(viewContext: viewContext, name: categoryName)
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                         didErrorCreatingCategory = true
                        }
                    }
                } label: {
                    Text("Add")
                }
                .alert("Failed to create category.", isPresented: $didErrorCreatingCategory, actions: {
                    Button("OK", role: .cancel) {}
                })
                .buttonStyle(.borderedProminent)
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.bordered)

                if !store.hasPurchasedAdsProduct {
                    Spacer()
                    GADAddItemsLargeRectangleBannerViewController()
                        .frame(width: GADAdSizeMediumRectangle.size.width, height: GADAdSizeMediumRectangle.size.height, alignment: .center)
                }
            }
            .frame(width: reader.size.width, alignment: .center)
        }
        .background(Color.Theme.linen)
    }
}
