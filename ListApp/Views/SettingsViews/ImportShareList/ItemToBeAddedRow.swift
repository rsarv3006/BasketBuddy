import SwiftUI

struct ItemToBeAddedRow: View {
    var item: ShareListItem
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(item.itemName)
                            .foregroundColor(Color.Theme.linen)
                        Text("\(String(item.itemCount)) \(item.unitAbbreviation)")
                            .foregroundColor(Color.Theme.linen)
                        Text("Category: \(item.categoryName)")
                            .foregroundColor(Color.Theme.linen)
                    }
                    .padding(.leading)
                }
                
                Spacer()
                if self.isSelected {
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .foregroundColor(Color.Theme.linen)
                        .padding(.trailing)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color.Theme.seaGreen)
            .cornerRadius(12)
            
        }
    }
}

struct ItemToBeAddedRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemToBeAddedRow(item: ShareListItem(itemName: "Test Item", itemCount: "1", unitName: "Pounds", unitAbbreviation: "lb", categoryName: "Bakery"), isSelected: true) {}
    }
}
