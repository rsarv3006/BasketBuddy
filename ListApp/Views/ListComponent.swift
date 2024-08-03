import SwiftUI

struct ListComponent: View {
    @EnvironmentObject var selectedStore: SelectedStore
    
    private var listItems: SectionedFetchResults<String, ListItem>
    init(listItems: SectionedFetchResults<String, ListItem>) {
        self.listItems = listItems
    }
    
    var body: some View {
        List {
            ForEach(listItems) { section in
                Section(header: Text(section.id).foregroundColor(Color.Theme.seaGreen)) {
                    ForEach(section) { item in
                        ListComponentItem(item: item, selectedItem: $selectedStore.selectedListItem, onTapGesture: {
                            ListItem.addMoveToBasketDate(item)
                            selectedStore.selectedListItem = nil
                        },
                        selectedImageName: "cart.badge.plus"
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .onTapGesture { self.handleOnTapGesture(item: item) }
                    }
                }
            }
        }
        .background(Color.Theme.linen)
        .scrollContentBackground(.hidden)
        .frame(maxWidth: .infinity)
    }
    
    private func handleOnTapGesture(item: SectionedFetchResults<String, ListItem>.Section.Element) {
        if selectedStore.selectedListItem == item {
            selectedStore.selectedListItem = nil
        } else {
            selectedStore.selectedListItem = item
        }
    }
}
