import Foundation

public struct TemplateVariable: Decodable, Equatable {
    public var id: String?
    public var key: String
    public var type: TemplateVariableType
    public var fallbackValue: TemplateVariableValue?
    public var createdAt: Date?
    public var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case key
        case type
        case fallbackValue = "fallback_value"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public struct Template: Decodable {
    public var id: String
    public var currentVersionId: String?
    public var name: String
    public var alias: String?
    public var from: String?
    public var subject: String?
    public var replyTo: [String]?
    public var html: String?
    public var text: String?
    public var variables: [TemplateVariable]?
    public var status: TemplateStatus
    public var publishedAt: Date?
    public var hasUnpublishedVersions: Bool?
    public var createdAt: Date
    public var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case currentVersionId = "current_version_id"
        case name
        case alias
        case from
        case subject
        case replyTo = "reply_to"
        case html
        case text
        case variables
        case status
        case publishedAt = "published_at"
        case hasUnpublishedVersions = "has_unpublished_versions"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public struct TemplateSummary: Decodable {
    public var id: String
    public var name: String
    public var status: TemplateStatus
    public var publishedAt: Date?
    public var createdAt: Date
    public var updatedAt: Date?
    public var alias: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case publishedAt = "published_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case alias
    }
}

public struct TemplateCreateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct TemplateUpdateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct TemplatePublishResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct TemplateDuplicateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct TemplateDeleteResponse: Decodable {
    public var id: String
    public var deleted: Bool
    
    init(id: String, deleted: Bool) {
        self.id = id
        self.deleted = deleted
    }
}

public struct TemplateListResponse: Decodable {
    public var hasMore: Bool
    public var data: [TemplateSummary]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        data = try container.decode([TemplateSummary].self, forKey: .data)
    }
}
