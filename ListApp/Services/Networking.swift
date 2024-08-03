import Foundation
import Bedrock
import Combine

struct Networking {
    private static func apiCall(httpMethod: HttpMethod, url: URL, body: Data? = nil) async throws -> (Data, URLResponse) {
        guard let token = await ConfigService.shared.getConfig()?.anonToken else {
            throw ServiceErrors.custom(message: "Token not found.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let response = try await URLSession.shared.data(for: request)
        
        return response
    }
    
    static func get(url: URL, body: Data? = nil) async throws -> (Data, URLResponse) {
        try await apiCall(httpMethod: .get, url: url, body: body)
    }
    
    static func post(url: URL, body: Data? = nil) async throws -> (Data, URLResponse) {
        try await apiCall(httpMethod: .post, url: url, body: body)
    }
    
    static func put(url: URL, body: Data? = nil) async throws -> (Data, URLResponse) {
        try await apiCall(httpMethod: .put, url: url, body: body)
    }
    
    static func patch(url: URL, body: Data? = nil) async throws -> (Data, URLResponse) {
        try await apiCall(httpMethod: .patch, url: url, body: body)
    }
    
    static func delete(url: URL, body: Data? = nil) async throws -> (Data, URLResponse) {
        try await apiCall(httpMethod: .delete, url: url, body: body)
    }
    
    static func createUrl(endPoint: String) async throws -> URL {
        guard let baseUrl = await ConfigService.shared.getConfig()?.apiUrl else {
            throw ServiceErrors.baseUrlNotConfigured
        }
        
        let url = URL(string: "\(baseUrl)\(endPoint)")
        
        guard let url = url else {
            throw ServiceErrors.unknownUrl
        }
        
        return url
    }
}

