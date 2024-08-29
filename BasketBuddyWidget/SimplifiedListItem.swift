import AppIntents
import Foundation

public struct SimplifiedListItem: Codable {
    let count: String
    let name: String?
    let unitAbbrv: String?
    let categoryName: String?
}

extension SimplifiedListItem: Hashable {}

extension SimplifiedListItem: Sendable {}

// MARK: - init from ListItem

public extension SimplifiedListItem {
    init(listItem: ListItem) {
        count = listItem.count
        name = listItem.name
        unitAbbrv = listItem.unit?.abbreviation
        categoryName = listItem.category?.name
    }
}
