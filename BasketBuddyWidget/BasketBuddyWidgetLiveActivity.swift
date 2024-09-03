import ActivityKit
import WidgetKit
import SwiftUI

struct BasketBuddyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BasketBuddyWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Items Left: \(context.state.itemCount)")
                Text("Next: \(parseItemForMediumSystemItemText(item: context.state.nextItem))")
            }
            .activityBackgroundTint(Color("SeaGreen"))
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("\(context.state.itemCount) Left")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    EmptyView()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Next: \(parseItemForMediumSystemItemText(item: context.state.nextItem))")
                }
            } compactLeading: {
                Text("\(context.state.itemCount)")
            } compactTrailing: {
                Text("\(context.state.nextItem.name ?? "")")
            } minimal: {
                Text("\(context.state.nextItem.name ?? "")")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color("SeaGreen"))
        }
    }
}

extension BasketBuddyWidgetAttributes {
    fileprivate static var preview: BasketBuddyWidgetAttributes {
        BasketBuddyWidgetAttributes()
    }
}

//extension BasketBuddyWidgetAttributes.ContentState {
//    fileprivate static var smiley: BasketBuddyWidgetAttributes.ContentState {
//        BasketBuddyWidgetAttributes.ContentState(emoji: "😀", itemCount: 2)
//     }
//     
//     fileprivate static var starEyes: BasketBuddyWidgetAttributes.ContentState {
//         BasketBuddyWidgetAttributes.ContentState(emoji: "🤩", itemCount: 2)
//     }
//}
