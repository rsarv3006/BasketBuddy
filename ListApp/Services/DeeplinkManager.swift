import Foundation

class DeeplinkManager {
    
    enum DeeplinkTarget: Equatable {
        case home
        case share(shareCode: String)
    }
    
    class DeepLinkConstants {
        static let host = "basketbuddy.rjs-app-dev.us"
        static let detailsPath = "/share"
        static let query = "shareCodeId"
    }
    
    func manage(url: URL) -> DeeplinkTarget {
        print(url)
        guard url.scheme == "https",
              url.host == DeepLinkConstants.host,
              url.path == DeepLinkConstants.detailsPath,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems
        else { return .home }
        
        let query = queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
        
        guard let shareCodeId = query[DeepLinkConstants.query] else { return .home }
        
        return .share(shareCode: shareCodeId)
    }
}
