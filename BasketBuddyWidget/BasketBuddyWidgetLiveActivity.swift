//
//  BasketBuddyWidgetLiveActivity.swift
//  BasketBuddyWidget
//
//  Created by Robert J. Sarvis Jr on 11/8/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BasketBuddyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BasketBuddyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BasketBuddyWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension BasketBuddyWidgetAttributes {
    fileprivate static var preview: BasketBuddyWidgetAttributes {
        BasketBuddyWidgetAttributes(name: "World")
    }
}

extension BasketBuddyWidgetAttributes.ContentState {
    fileprivate static var smiley: BasketBuddyWidgetAttributes.ContentState {
        BasketBuddyWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: BasketBuddyWidgetAttributes.ContentState {
         BasketBuddyWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: BasketBuddyWidgetAttributes.preview) {
   BasketBuddyWidgetLiveActivity()
} contentStates: {
    BasketBuddyWidgetAttributes.ContentState.smiley
    BasketBuddyWidgetAttributes.ContentState.starEyes
}