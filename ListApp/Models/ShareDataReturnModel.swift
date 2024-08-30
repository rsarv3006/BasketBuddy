import Foundation

struct ShareDataReturnModel: Codable {
    let data: [ShareListItem]
    let message: String
    let shareCode: String
}
