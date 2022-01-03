//
//  AddItems.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI
import CoreData

struct AddItems: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var itemName: String = ""
    @State var itemCount: String = ""
    @State var itemNameError: Bool = false
    @State var itemCountError: Bool = false
    
//    @State private var selectedCategory: Category
//    @State private var selectedUnit: Unit
//
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], animation: .default) private var categories: FetchedResults<Category>
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Unit.name, ascending: true)], animation: .default)
//    private var units: FetchedResults<Unit>
    
    @FetchRequest private var categories: FetchedResults<Category>
    @State private var selectedCategory: Category
    @FetchRequest private var units: FetchedResults<Unit>
    @State private var selectedUnit: Unit
    
    init() {
        let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoryFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
        categoryFetchRequest.predicate = NSPredicate(value: true)
        self._categories = FetchRequest(fetchRequest: categoryFetchRequest)
        
        let unitFetchRequest: NSFetchRequest<Unit> = Unit.fetchRequest()
        unitFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Unit.name, ascending: true)]
        unitFetchRequest.predicate = NSPredicate(value: true)
        self._units = FetchRequest(fetchRequest: unitFetchRequest)
        
        do {
            let tempCategories = try PersistenceController.shared.container.viewContext.fetch(categoryFetchRequest)
            self._selectedCategory = State(initialValue: tempCategories.first!)
            
            let tempUnits = try PersistenceController.shared.container.viewContext.fetch(unitFetchRequest)
            self._selectedUnit = State(initialValue: tempUnits.first!)
        } catch {
            fatalError("Init Problem")
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    Text("Add Items Screen")
                    Text("Category:\(selectedCategory.name ?? "")")
                    Text("Unit:\(selectedUnit.name ?? "")")
                    
                    VStack {
                        TextField("Item", text: $itemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: geometry.size.width * 0.8, alignment: .center)
                        if itemNameError {
                            Text("Item Name is required")
                                .foregroundColor(.red)
                        }
                    }
                    Picker("Select a Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.name ?? "")
                        }
                    }
                    .frame(width: geometry.size.width * 0.8, alignment: .center)
                    .pickerStyle(WheelPickerStyle())
                    .border(.gray, width: 2)
                    HStack {
                        VStack {
                            TextField("#", text: $itemCount)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: geometry.size.width * 0.2, alignment: .center)
                            if itemCountError {
                                Text("Item Count is required")
                                    .foregroundColor(.red)
                            }
                        }
                        Picker("Select a Unit", selection: $selectedUnit) {
                            ForEach(units, id: \.self) { unit in
                                Text(unit.name ?? "")
                            }
                        }
                        .frame(width: geometry.size.width * 0.4,alignment: .center)
                    }
                    .frame(width: geometry.size.width * 0.8, alignment: .center)
                    
                    VStack {
                        Button {
                            if (itemName.isEmpty || itemCount.isEmpty) {
                                itemNameError = itemName.isEmpty
                                itemCountError = itemCount.isEmpty
                            } else {
                                let context = PersistenceController.shared.container.viewContext
                                itemNameError = itemName.isEmpty
                                itemCountError = itemCount.isEmpty
                                
                                let item = ListItem(context: context)
                                item.name = itemName
                                item.count = Double(itemCount) ?? 1
                                item.unit = selectedUnit
                                item.category = selectedCategory
                                
                                do {
                                    try context.save()
                                } catch let error as NSError {
                                    print(error.userInfo)
                                }
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
                .frame(width: geometry.size.width, alignment: .center)
            }
        }
    }
}

struct AddItems_Previews: PreviewProvider {
    static var previews: some View {
        AddItems()
    }
}
