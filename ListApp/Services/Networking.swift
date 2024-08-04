import Foundation
import Bedrock
import Combine

struct BasketBuddyUrlProvider: URLProvider {
    func getBaseURL() async throws -> String {
        guard let baseUrl = await ConfigService.shared.getConfig()?.apiUrl else {
            throw ServiceErrors.baseUrlNotConfigured
        }
        return baseUrl
    }
}

struct ConfigTokenProvider: TokenProvider {
    func getToken() async throws -> String {
        guard let token = await ConfigService.shared.getConfig()?.anonToken else {
            throw ServiceErrors.custom(message: "Token not found.")
        }
        return token
    }
}

struct UserTokenProvider: TokenProvider {
    func getToken() async throws -> String {
        throw ServiceErrors.custom(message: "Not Implemented")
    }
}

public extension Networking {
    static let shared = Networking(urlProvider: BasketBuddyUrlProvider(), dynamicTokenProvider: DynamicTokenProvider(configTokenProvider: ConfigTokenProvider(), userTokenProvider: UserTokenProvider()))
}
