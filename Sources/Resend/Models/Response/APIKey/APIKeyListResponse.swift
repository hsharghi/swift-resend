import Foundation

public struct APIKeyListResponse: Decodable {
    public var data: [APIKey]
}

public struct APIKey: Decodable {
    public var id: String
    public var name: String
    public var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
    }
} 