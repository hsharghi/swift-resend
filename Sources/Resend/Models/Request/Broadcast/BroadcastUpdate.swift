import Foundation

public struct BroadcastUpdate: Encodable {
    public var id: String
    /// The ID of the segment you want to send to.
    public var segmentId: String?
    public var from: EmailAddress?
    public var subject: String?
    public var replyTo: [EmailAddress]?
    public var html: String?
    public var text: String?
    public var name: String?

    /// Audiences are now called Segments. Prefer `segmentId`.
    @available(*, deprecated, renamed: "segmentId", message: "Audiences have been replaced by Segments. Use segmentId instead.")
    public var audienceId: String? {
        get { segmentId }
        set { segmentId = newValue }
    }

    public init(id: String, segmentId: String? = nil, from: EmailAddress? = nil, subject: String? = nil, replyTo: [EmailAddress]? = nil, html: String? = nil, text: String? = nil, name: String? = nil) {
        self.id = id
        self.segmentId = segmentId
        self.from = from
        self.subject = subject
        self.replyTo = replyTo
        self.html = html
        self.text = text
        self.name = name
    }

    /// Audiences are now called Segments. Prefer `init(id:segmentId:...)`.
    @available(*, deprecated, message: "Audiences have been replaced by Segments. Use init(id:segmentId:...) instead.")
    public init(id: String, audienceId: String?, from: EmailAddress? = nil, subject: String? = nil, replyTo: [EmailAddress]? = nil, html: String? = nil, text: String? = nil, name: String? = nil) {
        self.init(id: id, segmentId: audienceId, from: from, subject: subject, replyTo: replyTo, html: html, text: text, name: name)
    }

    private enum CodingKeys: String, CodingKey {
        case id
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
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(segmentId, forKey: .segmentId)
        try container.encodeIfPresent(from?.string, forKey: .from)
        try container.encodeIfPresent(subject, forKey: .subject)
        try container.encodeIfPresent(replyTo?.stringArray, forKey: .replyTo)
        try container.encodeIfPresent(html, forKey: .html)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(name, forKey: .name)
    }
}
