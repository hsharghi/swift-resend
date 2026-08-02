import Foundation

public struct ContactProperty: Decodable {
    public var id: String
    public var key: String
    public var type: ContactPropertyType
    public var fallbackValue: ContactPropertyValue?
    public var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case key
        case type
        case fallbackValue = "fallback_value"
        case createdAt = "created_at"
    }
}

public struct ContactPropertyCreateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct ContactPropertyUpdateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct ContactPropertyDeleteResponse: Decodable {
    public var id: String
    public var deleted: Bool
    
    init(id: String, deleted: Bool) {
        self.id = id
        self.deleted = deleted
    }
}

public struct ContactPropertyListResponse: Decodable {
    public var hasMore: Bool
    public var data: [ContactProperty]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        data = try container.decode([ContactProperty].self, forKey: .data)
    }
}
