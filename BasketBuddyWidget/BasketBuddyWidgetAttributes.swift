import ActivityKit
import WidgetKit
import SwiftUI

struct BasketBuddyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public init(itemCount: Int, nextItem: SimplifiedListItem) {
            self.itemCount = itemCount
            self.nextItem = nextItem
        }
        
        // Dynamic stateful properties about your activity go here!
        var itemCount: Int
        var nextItem: SimplifiedListItem
    }
}
