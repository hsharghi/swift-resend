import Foundation

public struct BroadcastListResponse: Decodable {
    public var data: [BroadcastSummary]
}

public struct BroadcastSummary: Decodable {
    public var id: String
    public var audienceId: String
    public var status: String
    public var createdAt: Date
    public var scheduledAt: Date?
    public var sentAt: Date?

    private enum CodingKeys: String, CodingKey {
        case id
        case audienceId = "audience_id"
        case status
        case createdAt = "created_at"
        case scheduledAt = "scheduled_at"
        case sentAt = "sent_at"
    }
} 