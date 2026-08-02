import Foundation

public struct Webhook: Decodable {
    public var id: String
    public var endpoint: String
    public var events: [WebhookEventType]?
    public var status: WebhookStatus
    public var createdAt: Date
    public var signingSecret: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case endpoint
        case events
        case status
        case createdAt = "created_at"
        case signingSecret = "signing_secret"
    }
}

public struct WebhookSummary: Decodable {
    public var id: String
    public var endpoint: String
    public var events: [WebhookEventType]?
    public var status: WebhookStatus
    public var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case endpoint
        case events
        case status
        case createdAt = "created_at"
    }
}

public struct WebhookCreateResponse: Decodable {
    public var id: String
    public var signingSecret: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case signingSecret = "signing_secret"
    }
    
    init(id: String, signingSecret: String) {
        self.id = id
        self.signingSecret = signingSecret
    }
}

public struct WebhookUpdateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct WebhookDeleteResponse: Decodable {
    public var id: String
    public var deleted: Bool
    
    init(id: String, deleted: Bool) {
        self.id = id
        self.deleted = deleted
    }
}

public struct WebhookListResponse: Decodable {
    public var hasMore: Bool
    public var data: [WebhookSummary]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        data = try container.decode([WebhookSummary].self, forKey: .data)
    }
}
