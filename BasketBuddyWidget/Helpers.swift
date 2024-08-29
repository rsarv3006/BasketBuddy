import Foundation

public func parseItemForMediumSystemItemText(item: SimplifiedListItem) -> String {
    var unitAbbrv = item.unitAbbrv ?? ""
    unitAbbrv = unitAbbrv.isEmpty ? "" : "\(unitAbbrv) "
    return "\(item.count) \(unitAbbrv)\(item.name ?? "")"
}
