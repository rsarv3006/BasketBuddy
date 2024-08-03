import Foundation
import AppIntents

public struct SimplifiedListItem: Codable {
    let count: String
    let name: String?
    let unitAbbrv: String?
    let categoryName: String?
}

extension SimplifiedListItem: Hashable {}

// MARK: - init from ListItem
public extension SimplifiedListItem {
    init(listItem: ListItem) {
        self.count = listItem.count
        self.name = listItem.name
        self.unitAbbrv = listItem.unit?.abbreviation
        self.categoryName = listItem.category?.name
    }
}
