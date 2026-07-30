import Foundation

public struct Event: Decodable {
    public var id: String
    public var name: String
    public var schema: [String: EventSchemaFieldType]?
    public var createdAt: Date
    public var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case schema
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public struct EventCreateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct EventUpdateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct EventDeleteResponse: Decodable {
    public var id: String
    public var deleted: Bool
    
    init(id: String, deleted: Bool) {
        self.id = id
        self.deleted = deleted
    }
}

public struct EventListResponse: Decodable {
    public var hasMore: Bool
    public var data: [Event]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        data = try container.decode([Event].self, forKey: .data)
    }
}

public struct EventSendResponse: Decodable {
    public var event: String
}
