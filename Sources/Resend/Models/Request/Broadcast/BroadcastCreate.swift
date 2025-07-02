import Foundation

public struct BroadcastCreate: Encodable {
    /// The ID of the audience you want to send to.
    public var audienceId: String
    /// Sender email address. To include a friendly name, use the format "Your Name <sender@domain.com>".
    public var from: String
    /// Email subject.
    public var subject: String
    /// Reply-to email address. For multiple addresses, send as an array of strings.
    public var replyTo: [String]?
    /// The HTML version of the message.
    public var html: String?
    /// The plain text version of the message.
    public var text: String?
    /// The friendly name of the broadcast. Only used for internal reference.
    public var name: String?

    public init(audienceId: String, from: String, subject: String, replyTo: [String]? = nil, html: String? = nil, text: String? = nil, name: String? = nil) {
        self.audienceId = audienceId
        self.from = from
        self.subject = subject
        self.replyTo = replyTo
        self.html = html
        self.text = text
        self.name = name
    }

    private enum CodingKeys: String, CodingKey {
        case audienceId = "audience_id"
        case from
        case subject
        case replyTo = "reply_to"
        case html
        case text
        case name
    }
} 