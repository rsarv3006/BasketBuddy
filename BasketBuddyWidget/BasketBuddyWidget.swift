//
//  BasketBuddyWidget.swift
//  BasketBuddyWidget
//
//  Created by Robert J. Sarvis Jr on 11/8/23.
//

import WidgetKit
import SwiftUI
import UIKit
import CoreData

struct Provider: TimelineProvider {
    static let persistenceController = PersistenceController.shared
    let managedObjectContext = Self.persistenceController.container.viewContext
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), listItems: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), listItems: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
       
        var listItems: [SimplifiedListItem] = []
        do {
            listItems = try ListItem.getSimplifiedListItemsForWidget(managedObjectContext)
        } catch {
            print(error.localizedDescription)
        }
        
        let entry = SimpleEntry(date: Date(), listItems: listItems)
        
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let listItems: [SimplifiedListItem]
}

struct BasketBuddyWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("BasketBuddy")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.bottom, 2)
                .foregroundStyle(.seaGreen)
            
            if entry.listItems.isEmpty {
                Text("0 Items")
                    .foregroundStyle(.seaGreen)
                    .font(.footnote)
            }
            
            ForEach(entry.listItems, id: \.self) { item in
                switch family {
                case .systemSmall:
                    SmallSystemText(item: item)
                        .foregroundStyle(.seaGreen)
                        .font(.footnote)
                case .systemMedium:
                    MediumSystemText(item: item)
                        .foregroundStyle(.seaGreen)
                        .font(.footnote)
                case .systemLarge:
                    LargeSystemText(item: item)
                        .foregroundStyle(.seaGreen)
                        .font(.footnote)
                default:
                    SmallSystemText(item: item)
                        .foregroundStyle(.seaGreen)
                        .font(.footnote)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct SmallSystemText : View {
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

struct MediumSystemText : View {
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

func parseItemForMediumSystemItemText(item: SimplifiedListItem) -> String {
    var unitAbbrv = item.unitAbbrv ?? ""
    unitAbbrv = unitAbbrv.isEmpty ? "" : "\(unitAbbrv) "
    return "\(item.count) \(unitAbbrv)\(item.name ?? "")"
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

import AppIntents

struct MarkItemInBasketIntent: AppIntent {
    init() {}
    
    static var title: LocalizedStringResource = "Mark Item In Basket"
    static var description = IntentDescription("Mark an item as in the basket.")
    
    static let persistenceController = PersistenceController.shared
    let managedObjectContext = Self.persistenceController.container.viewContext
    
    @Parameter(title: "SimplifiedListItem")
    var simplifiedListItem: String

    init(simplifiedListItem: String) {
        self.simplifiedListItem = simplifiedListItem
    }

    func perform() async throws -> some IntentResult {
        let listItem = try ListItem.getItemFromItemName(managedObjectContext, itemName: simplifiedListItem)
        ListItem.addMoveToBasketDate(listItem)
        return .result()
    }
}


fileprivate let MockSimplifiedListItem: [SimplifiedListItem] = [
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
