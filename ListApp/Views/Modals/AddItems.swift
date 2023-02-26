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
    @State var isStaple: Bool = false
    
    @FetchRequest private var categories: FetchedResults<Category>
    @State private var selectedCategory: Category
    @FetchRequest private var units: FetchedResults<Unit>
    @State private var selectedUnit: Unit
    
    private var viewContext: NSManagedObjectContext
    
    @Binding var selectedItem: ListItem?
    
    init(viewContext: NSManagedObjectContext, selectedItem: Binding<ListItem?>) {
        self._selectedItem = selectedItem
        
        self.viewContext = viewContext
        let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoryFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
        categoryFetchRequest.predicate = NSPredicate(value: true)
        self._categories = FetchRequest(fetchRequest: categoryFetchRequest)
        
        let unitFetchRequest: NSFetchRequest<Unit> = Unit.fetchRequest()
        unitFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Unit.name, ascending: true)]
        unitFetchRequest.predicate = NSPredicate(value: true)
        self._units = FetchRequest(fetchRequest: unitFetchRequest)
        
        do {
            let tempCategories = try viewContext.fetch(categoryFetchRequest)
            let tempUnits = try viewContext.fetch(unitFetchRequest)
            
            if let selectedItem = selectedItem.wrappedValue {
                if let tempCat = selectedItem.category, let catIndex = tempCategories.firstIndex(of: tempCat) {
                    self._selectedCategory = State(initialValue: tempCategories[catIndex])
                } else {
                    self._selectedCategory = State(initialValue: tempCategories.first!)
                }
                
                if let tempUnit = selectedItem.unit, let unitIndex = tempUnits.firstIndex(of: tempUnit) {
                    self._selectedUnit = State(initialValue: tempUnits[unitIndex])
                } else {
                    self._selectedUnit = State(initialValue: tempUnits.first!)
                }
                
                self._itemName = State(initialValue: selectedItem.name ?? "")
                self._itemCount = State(initialValue: String(selectedItem.count))
                self._isStaple = State(initialValue: selectedItem.isStaple)
            } else {
                self._selectedCategory = State(initialValue: tempCategories.first!)
                self._selectedUnit = State(initialValue: tempUnits.first!)
            }
            
        } catch {
            fatalError("Init Problem")
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                Text("Add Item")
                    .padding(.top)
                    .foregroundColor(Color.theme.seaGreen)
                VStack {
                    TextField("Item", text: $itemName)
                        .foregroundColor(Color.theme.seaGreen)
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
                            .foregroundColor(Color.theme.seaGreen)
                    }
                }
                .frame(width: geometry.size.width * 0.8, alignment: .center)
                .pickerStyle(WheelPickerStyle())
                .border(Color.theme.seaGreen, width: 2)
                HStack {
                    VStack {
                        TextField("#", text: $itemCount)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: geometry.size.width * 0.2, alignment: .center)
                        if itemCountError {
                            Text("Item Count is required")
                                .foregroundColor(Color.theme.redMunsell)
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
                Toggle("Item is a Staple", isOn: $isStaple)
                    .foregroundColor(Color.theme.seaGreen)
                    .padding(.horizontal)
                    .padding(.bottom)
                    .frame(width: geometry.size.width * 0.8, alignment: .center)
                HStack {
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(Color.theme.redMunsell)
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                    Button {
                        if (itemName.isEmpty || itemCount.isEmpty) {
                            itemNameError = itemName.isEmpty
                            itemCountError = itemCount.isEmpty
                        } else {
                            itemNameError = itemName.isEmpty
                            itemCountError = itemCount.isEmpty
                            
                            if let tempSelectedItem = selectedItem {
                                ListItem.editItem(itemToEdit: tempSelectedItem, itemName: itemName, itemCount: itemCount, unit: selectedUnit, category: selectedCategory, isStaple: isStaple)
                                selectedItem = nil
                            } else {
                                ListItem.addItem(itemName: itemName, itemCount: itemCount, unit: selectedUnit, category: selectedCategory, isStaple: isStaple, viewContext: viewContext)
                            }
                            
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        if (selectedItem == nil) {
                            Text("Add")
                        } else {
                            Text("Save")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                
            }
            .frame(width: geometry.size.width, alignment: .center)
            .background(Color.theme.linen)
        }
    }
    
}

//struct AddItems_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItems()
//    }
//}
