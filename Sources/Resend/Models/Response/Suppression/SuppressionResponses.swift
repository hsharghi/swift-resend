import Foundation

public struct Suppression: Decodable {
    public var id: String
    public var email: String
    public var origin: SuppressionOrigin
    public var sourceId: String?
    public var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case origin
        case sourceId = "source_id"
        case createdAt = "created_at"
    }
}

public struct SuppressionAddResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct SuppressionRemoveResponse: Decodable {
    public var id: String
    public var deleted: Bool
    
    init(id: String, deleted: Bool) {
        self.id = id
        self.deleted = deleted
    }
}

public struct SuppressionBatchAddItem: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct SuppressionBatchAddResponse: Decodable {
    public var data: [SuppressionBatchAddItem]
}

public struct SuppressionBatchRemoveItem: Decodable {
    public var id: String
    public var deleted: Bool
    
    init(id: String, deleted: Bool) {
        self.id = id
        self.deleted = deleted
    }
}

public struct SuppressionBatchRemoveResponse: Decodable {
    public var data: [SuppressionBatchRemoveItem]
}

public struct SuppressionListResponse: Decodable {
    public var hasMore: Bool
    public var data: [Suppression]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        data = try container.decode([Suppression].self, forKey: .data)
    }
}
