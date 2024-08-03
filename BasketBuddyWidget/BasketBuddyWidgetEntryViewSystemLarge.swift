import SwiftUI
import WidgetKit

struct BasketBuddyWidgetEntryViewSystemLarge: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack
            {
                Text("BasketBuddy")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.seaGreen)
                
                if !entry.listItems.isEmpty {
                    Spacer()
                    CircleText(text: String(describing: entry.listItems.count))
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if entry.listItems.isEmpty {
                Text("0 Items")
                    .foregroundStyle(.seaGreen)
                    .font(.subheadline)
            }
            
            ForEach(entry.listItems.prefix(10), id: \.self) { item in
                Button(intent: MarkItemInBasketIntent(simplifiedListItem: item.name ?? "")) {
                    HStack {
                        Circle()
                            .strokeBorder(.seaGreen, lineWidth: 1.5)
                            .frame(width: 12, height: 12)
                            .padding(.trailing, -4)
                        Text(parseItemForMediumSystemItemText(item: item))
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(.subheadline)
                            .foregroundStyle(.seaGreen)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

let MockSimplifiedListItemLong: [SimplifiedListItem] = [
    SimplifiedListItem(count: "2", name: "waffles", unitAbbrv: "dz", categoryName: "frozen"),
    SimplifiedListItem(count: "1", name: "tortillas", unitAbbrv: "dz", categoryName: "bakery"),
    SimplifiedListItem(count: "3", name: "bags of chips", unitAbbrv: "", categoryName: "bulk"),
    SimplifiedListItem(count: "3", name: "more bags of chips", unitAbbrv: "", categoryName: "bulk"),
    SimplifiedListItem(count: "2", name: "waffles", unitAbbrv: "dz", categoryName: "frozen"),
    SimplifiedListItem(count: "1", name: "tortillas", unitAbbrv: "dz", categoryName: "bakery"),
    SimplifiedListItem(count: "3", name: "bags of chips", unitAbbrv: "", categoryName: "bulk"),
    SimplifiedListItem(count: "3", name: "more bags of chips", unitAbbrv: "", categoryName: "bulk"),
    SimplifiedListItem(count: "3", name: "bags of chips", unitAbbrv: "", categoryName: "bulk"),
    SimplifiedListItem(count: "3", name: "more bags of chips", unitAbbrv: "", categoryName: "bulk"),
]

#Preview(as: .systemLarge) {
    BasketBuddyWidget()
} timeline: {
    SimpleEntry(date: .now, listItems: MockSimplifiedListItemLong)
}

