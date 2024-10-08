import SwiftUI
import CoreData

struct AddItems: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var itemName: String = ""
    @State var itemCount: String = ""
    @State var itemNameError: Bool = false
    @State var itemCountError: Bool = false
    @State var isStaple: Bool = false
    @State var aisleNumber: String = ""

    @FetchRequest private var categories: FetchedResults<Category>
    @State private var selectedCategory: Category
    @FetchRequest private var units: FetchedResults<Unit>
    @State private var selectedUnit: Unit

    private var viewContext: NSManagedObjectContext

    @Binding var selectedItem: ListItem?

    init(viewContext: NSManagedObjectContext, selectedItem: Binding<ListItem?>, isStaple: Bool = false) {
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

        self._isStaple = State(initialValue: isStaple)
        
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
                self._aisleNumber = State(initialValue: selectedItem.aisleNumber ?? "")
                self._itemCount = State(initialValue: String(selectedItem.count))
                self._isStaple = State(initialValue: selectedItem.isStaple)
            } else {
                self._selectedCategory = State(initialValue: tempCategories.first!)
                let tempUnit = tempUnits.first { unitToCheck in
                    return unitToCheck.name == "Item(s)"
                }
                self._selectedUnit = State(initialValue: tempUnit ?? tempUnits.first!)
            }
        } catch {
            fatalError("Init Problem")
        }
    }

    var body: some View {
        GeometryReader { reader in
            ScrollView(showsIndicators: false) {
                Text("Add Item")
                    .padding(.top)
                    .foregroundColor(Color.Theme.seaGreen)

                VStack {
                    TextField("Item", text: $itemName)
                        .foregroundColor(Color.Theme.seaGreen)
                        .textFieldStyle(TextFieldDefaultBackgroundSeagreenBorder())

                    if itemNameError {
                        Text("Item Name is required")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)

                Picker("Select a Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category.name ?? "")
                            .foregroundColor(Color.Theme.seaGreen)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.Theme.seaGreen, lineWidth: 2))
                .padding(.horizontal)

                HStack {
                    VStack {
                        TextField("#", text: $itemCount)
                            .foregroundColor(Color.Theme.seaGreen)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(TextFieldDefaultBackgroundSeagreenBorder())
                        if itemCountError {
                            Text("Item Count is required")
                                .foregroundColor(Color.Theme.redMunsell)
                        }
                    }
                    Picker("Select a Unit", selection: $selectedUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit.name ?? "")
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Aisle:")
                        .foregroundStyle(Color.Theme.seaGreen)
                    
                    TextField("Aisle", text: $aisleNumber)
                        .foregroundColor(Color.Theme.seaGreen)
                        .textFieldStyle(TextFieldDefaultBackgroundSeagreenBorder())
                }
                .padding(.horizontal)

                Toggle("Item is a Staple", isOn: $isStaple)
                    .foregroundColor(Color.Theme.seaGreen)
                    .padding([.horizontal, .bottom])

                HStack {
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .padding(.horizontal)
                            .foregroundColor(Color.Theme.redMunsell)
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                    Button {
                        if itemName.isEmpty || itemCount.isEmpty {
                            itemNameError = itemName.isEmpty
                            itemCountError = itemCount.isEmpty
                        } else {
                            itemNameError = itemName.isEmpty
                            itemCountError = itemCount.isEmpty

                            if let tempSelectedItem = selectedItem {
                                ListItem.editItem(itemToEdit: tempSelectedItem, itemName: itemName, itemCount: itemCount, unit: selectedUnit, category: selectedCategory, isStaple: isStaple, aisleNumber: aisleNumber)
                                selectedItem = nil
                            } else {
                                ListItem.addItem(itemName: itemName, itemCount: itemCount, unit: selectedUnit, category: selectedCategory, isStaple: isStaple, aisleNumber: aisleNumber, viewContext: viewContext)
                            }

                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        if selectedItem == nil {
                            Text("Add")
                                .foregroundColor(Color.Theme.linen)
                                .padding(.horizontal)
                        } else {
                            Text("Save")
                                .foregroundColor(Color.Theme.linen)
                                .padding(.horizontal)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
            }
            .background(Color.Theme.linen)
        }
    }
}
