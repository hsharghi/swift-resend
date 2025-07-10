import Foundation

public struct BroadcastGetResponse: Decodable {
    public var id: String
    public var name: String?
    public var audienceId: String
    public var from: EmailAddress
    public var subject: String
    public var replyTo: [EmailAddress]?
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        audienceId = try container.decode(String.self, forKey: .audienceId)
        
        let fromString = try container.decode(String.self, forKey: .from)
        from = EmailAddress(from: fromString)
        
        subject = try container.decode(String.self, forKey: .subject)
        
        if let replyToStrings = try container.decodeIfPresent([String].self, forKey: .replyTo) {
            replyTo = replyToStrings.map { EmailAddress(from: $0) }
        } else {
            replyTo = nil
        }
        
        previewText = try container.decodeIfPresent(String.self, forKey: .previewText)
        status = try container.decode(String.self, forKey: .status)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        scheduledAt = try container.decodeIfPresent(Date.self, forKey: .scheduledAt)
        sentAt = try container.decodeIfPresent(Date.self, forKey: .sentAt)
    }
} 