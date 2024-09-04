import Foundation

public class ShareListItem: Codable {
    let itemName: String
    let itemCount: String
    let unitName: String
    let unitAbbreviation: String
    let categoryName: String
    let aisleNumber: String?
    
    init(itemName: String, itemCount: String, unitName: String, unitAbbreviation: String, categoryName: String, aisleNumber: String? = nil) {
        self.itemName = itemName
        self.itemCount = itemCount
        self.unitName = unitName
        self.unitAbbreviation = unitAbbreviation
        self.categoryName = categoryName
        self.aisleNumber = aisleNumber
    }
}

extension ShareListItem: Identifiable {}

extension ShareListItem: Hashable {
    public static func == (lhs: ShareListItem, rhs: ShareListItem) -> Bool {
        return lhs.itemName == rhs.itemName && lhs.itemCount == rhs.itemCount && lhs.unitName == rhs.unitName && lhs.unitAbbreviation == rhs.unitAbbreviation && lhs.categoryName == rhs.categoryName && lhs.aisleNumber == rhs.aisleNumber
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(itemName)
        hasher.combine(itemCount)
        hasher.combine(unitName)
        hasher.combine(unitAbbreviation)
        hasher.combine(categoryName)
    }

}
