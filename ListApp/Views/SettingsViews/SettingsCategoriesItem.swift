import SwiftUI

struct SettingsCategoriesItem: View {
    @Environment(\.colorScheme) var colorScheme

    let category: Category
    @EnvironmentObject var selectedStore: SelectedStore

    var unSelectedView: some View {
        VStack {
            Text(category.name ?? "")
                .foregroundColor(Color.Theme.linen)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        // TODO This is a pain in the ass hack because the above ^ doesn't want to apply to just text
        .background(Color.Theme.seaGreen)

    }

    var selectedView: some View {
        HStack {
            Image(systemName: "checkmark")
                .foregroundColor(Color.Theme.redMunsell)
            unSelectedView
        }
    }

    var body: some View {
        if let selectedCat = selectedStore.selectedCategory, selectedCat == category {
            selectedView
        } else {
            unSelectedView
        }

    }
}

// struct SettingsCategoriesItem_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsCategoriesItem(category: Category())
//    }
// }
