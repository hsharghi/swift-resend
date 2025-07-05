import Foundation

public struct BroadcastGetResponse: Decodable {
    public var id: String
    public var name: String?
    public var audienceId: String
    public var from: String
    public var subject: String
    public var replyTo: [String]?
    public var previewText: String?
    public var status: String
    public var createdAt: Date
    public var scheduledAt: Date?
    public var sentAt: Date?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case audienceId = "audience_id"
        case from
        case subject
        case replyTo = "reply_to"
        case previewText = "preview_text"
        case status
        case createdAt = "created_at"
        case scheduledAt = "scheduled_at"
        case sentAt = "sent_at"
    }
} 