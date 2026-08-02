import Foundation

public struct BroadcastCreate: Encodable {
    /// The ID of the segment you want to send to.
    public var segmentId: String
    /// Sender email address with optional friendly name.
    public var from: EmailAddress
    /// Email subject.
    public var subject: String
    /// Reply-to email addresses with optional friendly names.
    public var replyTo: [EmailAddress]?
    /// The HTML version of the message.
    public var html: String?
    /// The plain text version of the message.
    public var text: String?
    /// The friendly name of the broadcast. Only used for internal reference.
    public var name: String?

    /// Audiences are now called Segments. Prefer `segmentId`.
    @available(*, deprecated, renamed: "segmentId", message: "Audiences have been replaced by Segments. Use segmentId instead.")
    public var audienceId: String {
        get { segmentId }
        set { segmentId = newValue }
    }

    public init(segmentId: String, from: EmailAddress, subject: String, replyTo: [EmailAddress]? = nil, html: String? = nil, text: String? = nil, name: String? = nil) {
        self.segmentId = segmentId
        self.from = from
        self.subject = subject
        self.replyTo = replyTo
        self.html = html
        self.text = text
        self.name = name
    }

    /// Audiences are now called Segments. Prefer `init(segmentId:...)`.
    @available(*, deprecated, message: "Audiences have been replaced by Segments. Use init(segmentId:from:subject:...) instead.")
    public init(audienceId: String, from: EmailAddress, subject: String, replyTo: [EmailAddress]? = nil, html: String? = nil, text: String? = nil, name: String? = nil) {
        self.init(segmentId: audienceId, from: from, subject: subject, replyTo: replyTo, html: html, text: text, name: name)
    }

    private enum CodingKeys: String, CodingKey {
        case segmentId = "segment_id"
        case from
        case subject
        case replyTo = "reply_to"
        case html
        case text
        case name
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(segmentId, forKey: .segmentId)
        try container.encode(from.string, forKey: .from)
        try container.encode(subject, forKey: .subject)
        try container.encodeIfPresent(replyTo?.stringArray, forKey: .replyTo)
        try container.encodeIfPresent(html, forKey: .html)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(name, forKey: .name)
    }
}
