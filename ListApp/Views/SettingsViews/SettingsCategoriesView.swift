import SwiftUI

struct SettingsCategoriesView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var selectedStore: SelectedStore
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: false)], animation: .default)
    private var categories: FetchedResults<Category>
    
    @State var showAdd: Bool = false
    @State var isDeleteAlertVisible = false
    
    var body: some View {
        VStack {
            ZStack {
                List {
                    ForEach(categories) { category in
                        SettingsCategoriesItem(category: category)
                            .listRowBackground(Color.Theme.seaGreen)
                            .onTapGesture {
                                if selectedStore.selectedCategory == category {
                                    selectedStore.selectedCategory = nil
                                } else {
                                    selectedStore.selectedCategory = category
                                }
                                
                            }
                    }
                    .onDelete { indexSet in
                        let categoriesCount = categories.count
                        indexSet.forEach { index in
                            if index < categoriesCount {
                                CategoryModel.delete(categories[index])
                            }
                        }
                        
                    }
                }
                if categories.isEmpty {
                    Spacer()
                        .background(Color.Theme.linen)
                }
            }
            .background(Color.Theme.linen)
            .scrollContentBackground(.hidden)
            .toolbar {
                SettingsCategoriesBottomToolbar(selectedCategory: $selectedStore.selectedCategory, showAdd: $showAdd, isDeleteAlertVisible: $isDeleteAlertVisible)
            }
            .sheet(isPresented: $showAdd) {
                SettingsAddCategory()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Categories")
                            .font(.headline)
                            .foregroundColor(Color.Theme.seaGreen)
                    }
                }
            }
            .onAppear {
                selectedStore.selectedCategory = nil
            }
        }
        .background(Color.Theme.linen)
    }
}
