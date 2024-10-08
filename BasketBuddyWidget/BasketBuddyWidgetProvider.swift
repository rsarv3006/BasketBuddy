import WidgetKit
import SwiftUI
import UIKit
import CoreData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), listItems: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), listItems: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        
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
