import Foundation
import Bedrock

struct ShareService {
    static func createShare(items: ShareListDto) async throws -> String {
        let url = try await Networking.shared.createUrl(endPoint: "/api/v1/share/")
        
        let shareListItemData = try JSONEncoder().encode(items)

        let (data, response) = try await Networking.shared.post(url: url, body: shareListItemData)
        
        let decoder = JSONDecoder()
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            let shareCode = try decoder.decode(ShareCodeReturnModel.self, from: data)
            return shareCode.shareCode
        } else {
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            
            throw ServiceErrors.custom(message: serverError.error)
        }
    }
    
    static func getShare(shareId: String) async throws -> ShareDataReturnModel {
        let url = try await Networking.shared.createUrl(endPoint: "/api/v1/share/\(shareId)")
    
        let (data, response) = try await Networking.shared.get(url: url)
        
        let decoder = JSONDecoder()
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let shareData = try decoder.decode(ShareDataReturnModel.self, from: data)
            return shareData
            
        } else {
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.error)
        }
    }
    
    static func convertListItemsToShareListDto(listItems: Set<ListItem>) -> ShareListDto {
        var shareListItems = [ShareListItem]()
        
        for listItem in listItems {
            if let itemName = listItem.name, let unitName = listItem.unit?.name, let unitAbbreviation = listItem.unit?.abbreviation, let categoryName = listItem.category?.name {
                let shareListItem = ShareListItem(itemName: itemName, itemCount: listItem.count, unitName: unitName, unitAbbreviation: unitAbbreviation, categoryName: categoryName, aisleNumber: listItem.aisleNumber)
                shareListItems.append(shareListItem)
            }
        }
        
        return ShareListDto(data: shareListItems)
    }
}
