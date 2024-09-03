import WidgetKit
import SwiftUI
import UIKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let listItems: [SimplifiedListItem]
}

struct BasketBuddyWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemExtraLarge:
            BasketBuddyWidgetEntryViewSystemLarge(entry: entry)
        case .systemLarge:
            BasketBuddyWidgetEntryViewSystemLarge(entry: entry)
        case .systemMedium:
            BasketBuddyWidgetEntryViewSystemMedium(entry: entry)
        default:
            BasketBuddyWidgetEntryViewSystemSmall(entry: entry)
        }
    }
}

struct LargeSystemText : View {
    var item: SimplifiedListItem
    
    var body: some View {
        Button(intent: MarkItemInBasketIntent(simplifiedListItem: item.name ?? "")) {
            HStack {
                Circle()
                    .strokeBorder(.seaGreen, lineWidth: 1.5)
                    .frame(width: 12, height: 12)
                    .padding(.trailing, -4)
                Text(parseItemForMediumSystemItemText(item: item))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .buttonStyle(.plain)
    }
}

struct BasketBuddyWidget: Widget {
    let kind: String = "BasketBuddyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                BasketBuddyWidgetEntryView(entry: entry)
                    .containerBackground(Color(uiColor: UIColor(named: "Linen") ?? .systemBackground), for: .widget)
            } else {
                BasketBuddyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("BasketBuddy Widget")
        .description("Widget for BasketBuddy.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

let MockSimplifiedListItem: [SimplifiedListItem] = [
    SimplifiedListItem(count: "2", name: "waffles", unitAbbrv: "dz", categoryName: "frozen"),
    SimplifiedListItem(count: "1", name: "tortillas", unitAbbrv: "dz", categoryName: "bakery"),
    SimplifiedListItem(count: "3", name: "bags of chips", unitAbbrv: "", categoryName: "bulk"),
    SimplifiedListItem(count: "3", name: "more bags of chips", unitAbbrv: "", categoryName: "bulk"),
]

#Preview(as: .systemSmall) {
    BasketBuddyWidget()
} timeline: {
    SimpleEntry(date: .now, listItems: MockSimplifiedListItem)
}

#Preview(as: .systemMedium) {
    BasketBuddyWidget()
} timeline: {
    SimpleEntry(date: .now, listItems: MockSimplifiedListItem)
}

#Preview(as: .systemLarge) {
    BasketBuddyWidget()
} timeline: {
    SimpleEntry(date: .now, listItems: MockSimplifiedListItem)
}
