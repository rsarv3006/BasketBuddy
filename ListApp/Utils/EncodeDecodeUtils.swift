import Foundation

struct EncodeDecodeUtils {
    static func encodeToBase64String<T: Encodable>(_ value: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encodedData = try? encoder.encode(value)
        let base64String = encodedData?.base64EncodedString()
        return base64String
    }

    static func decodeFromBase64String<T: Decodable>(_ value: String) -> T? {
        guard let data = Data(base64Encoded: value) else { return nil }
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode(T.self, from: data)
        
        return decoded
    }
}

