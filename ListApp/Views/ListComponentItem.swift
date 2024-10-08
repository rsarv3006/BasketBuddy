import SwiftUI

struct ListComponentItem: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var selectedStore: SelectedStore
    
    let item: ListItem
    @Binding var selectedItem: ListItem?
    var onTapGesture: () -> Void
    var selectedImageName: String = "checkmark"
    
    var unSelectedView: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name ?? "")
                        .foregroundColor(Color.Theme.linen)
                    Text("\(String(item.count)) \(item.unit?.abbreviation ?? "")")
                        .foregroundColor(Color.Theme.linen)
                }
                .padding(.leading)
                
                Spacer()
                
                if let aisleInfo = item.aisleNumber, !aisleInfo.isEmpty {
                    VStack {
                        Text("")
                        Text("Aisle: \(aisleInfo)")
                            .foregroundColor(Color.Theme.linen)
                    }
                    .padding([.trailing], 8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.Theme.seaGreen)
        .cornerRadius(12)
        
    }

    var selectedView: some View {
        HStack {
            unSelectedView
            ZStack {
                Image(systemName: selectedImageName)
                    .foregroundColor(Color.Theme.seaGreen)
                    .fontWeight(.heavy)
                    .font(.largeTitle)
            }
            .onTapGesture(perform: onTapGesture)
        }
    }

    var body: some View {
        if let selectedItem = selectedItem, selectedItem == item {
            selectedView
        } else {
            unSelectedView
        }
    }
}
