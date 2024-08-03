import Foundation

class SelectedStore: ObservableObject {
    @Published var selectedListItem: ListItem?
    @Published var selectedCategory: Category?
    @Published var selectedStaple: ListItem?

    init() {}
}
