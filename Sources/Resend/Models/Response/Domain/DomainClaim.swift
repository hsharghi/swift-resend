import Foundation

public struct DomainClaimRecord: Decodable {
    public var type: String
    public var name: String
    public var value: String
    public var ttl: String?
}

public struct DomainClaim: Decodable {
    public var id: String
    public var name: String
    public var status: String
    public var domainId: String
    public var region: String?
    public var record: DomainClaimRecord?
    public var blockedReason: String?
    public var failureReason: String?
    public var createdAt: Date
    public var expiresAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case domainId = "domain_id"
        case region
        case record
        case blockedReason = "blocked_reason"
        case failureReason = "failure_reason"
        case createdAt = "created_at"
        case expiresAt = "expires_at"
    }
}
