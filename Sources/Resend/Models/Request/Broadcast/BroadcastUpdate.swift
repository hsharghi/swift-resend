import Foundation

public struct BroadcastUpdate: Encodable {
    public var id: String
    public var audienceId: String?
    public var from: String?
    public var subject: String?
    public var replyTo: [String]?
    public var html: String?
    public var text: String?
    public var name: String?

    public init(id: String, audienceId: String? = nil, from: String? = nil, subject: String? = nil, replyTo: [String]? = nil, html: String? = nil, text: String? = nil, name: String? = nil) {
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
} 