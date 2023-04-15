//
//  Networking.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 4/7/23.
//

import Foundation
import Combine

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

struct Networking {
    private static func apiCall(httpMethod: HttpMethod, url: URL, body: Data? = nil) async throws -> (Data, URLResponse) {
        guard let token = getKeyValueFromPlist(plistFileName: "Supabase", key: "AnonToken") else {
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
    
    static func createUrl(endPoint: String) throws -> URL {
        guard let baseUrl = getKeyValueFromPlist(plistFileName: "Supabase", key: "ApiUrl") else {
            throw ServiceErrors.baseUrlNotConfigured
        }
        
        let url = URL(string: "\(baseUrl)\(endPoint)")
        
        guard let url = url else {
            throw ServiceErrors.unknownUrl
        }
        
        return url
    }
    
    struct helpers {
        static func createQueryString(items: [String]) -> String {
            var returnString = ""
            for item in items {
                returnString += "\(item),"
            }
            
            if returnString.last == "," {
                _ = returnString.popLast()
            }
            
            return returnString
        }
    }
}

