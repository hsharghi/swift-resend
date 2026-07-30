import Foundation

public struct Automation: Decodable {
    public var id: String
    public var name: String
    public var status: AutomationStatus
    public var createdAt: Date
    public var updatedAt: Date?
    public var steps: [AutomationStep]?
    public var connections: [AutomationConnection]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case steps
        case connections
    }
}

public struct AutomationSummary: Decodable {
    public var id: String
    public var name: String
    public var status: AutomationStatus
    public var createdAt: Date
    public var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public struct AutomationCreateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct AutomationUpdateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}

public struct AutomationDeleteResponse: Decodable {
    public var id: String
    public var deleted: Bool
    
    init(id: String, deleted: Bool) {
        self.id = id
        self.deleted = deleted
    }
}

public struct AutomationStopResponse: Decodable {
    public var id: String
    public var status: AutomationStatus
}

public struct AutomationListResponse: Decodable {
    public var hasMore: Bool
    public var data: [AutomationSummary]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        data = try container.decode([AutomationSummary].self, forKey: .data)
    }
}

public struct AutomationRunStep: Decodable {
    public var key: String
    public var type: AutomationStepType
    public var status: String?
    public var startedAt: Date?
    public var completedAt: Date?
    public var createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case key
        case type
        case status
        case startedAt = "started_at"
        case completedAt = "completed_at"
        case createdAt = "created_at"
    }
}

public struct AutomationRun: Decodable {
    public var id: String
    public var status: AutomationRunStatus
    public var startedAt: Date?
    public var completedAt: Date?
    public var createdAt: Date
    public var steps: [AutomationRunStep]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case startedAt = "started_at"
        case completedAt = "completed_at"
        case createdAt = "created_at"
        case steps
    }
}

public struct AutomationRunSummary: Decodable {
    public var id: String
    public var status: AutomationRunStatus
    public var startedAt: Date?
    public var completedAt: Date?
    public var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case startedAt = "started_at"
        case completedAt = "completed_at"
        case createdAt = "created_at"
    }
}

public struct AutomationRunListResponse: Decodable {
    public var hasMore: Bool
    public var data: [AutomationRunSummary]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        data = try container.decode([AutomationRunSummary].self, forKey: .data)
    }
}
