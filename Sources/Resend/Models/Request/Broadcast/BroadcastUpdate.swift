import Foundation

public struct BroadcastUpdate: Encodable {
    public var id: String
    public var audienceId: String?
    public var from: EmailAddress?
    public var subject: String?
    public var replyTo: [EmailAddress]?
    public var html: String?
    public var text: String?
    public var name: String?

    public init(id: String, audienceId: String? = nil, from: EmailAddress? = nil, subject: String? = nil, replyTo: [EmailAddress]? = nil, html: String? = nil, text: String? = nil, name: String? = nil) {
        self.id = id
        self.audienceId = audienceId
        self.from = from
        self.subject = subject
        self.replyTo = replyTo
        self.html = html
        self.text = text
        self.name = name
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case audienceId = "audience_id"
        case from
        case subject
        case replyTo = "reply_to"
        case html
        case text
        case name
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(audienceId, forKey: .audienceId)
        try container.encodeIfPresent(from?.string, forKey: .from)
        try container.encodeIfPresent(subject, forKey: .subject)
        try container.encodeIfPresent(replyTo?.stringArray, forKey: .replyTo)
        try container.encodeIfPresent(html, forKey: .html)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(name, forKey: .name)
    }
} 