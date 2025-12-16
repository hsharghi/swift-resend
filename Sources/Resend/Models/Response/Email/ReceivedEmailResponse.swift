import Foundation

public struct ReceivedEmailResponse: Decodable {
    public var id: String
    public var to: [EmailAddress]
    public var from: EmailAddress
    public var createdAt: Date
    public var subject: String
    public var html: String?
    public var text: String?
    public var headers: [EmailHeaders]?
    public var bcc: [EmailAddress]
    public var cc: [EmailAddress]
    public var replyTo: [EmailAddress]
    public var messageId: String
    public var attachments: [ReceivedAttachment]
    
    enum CodingKeys: String, CodingKey {
        case id
        case to
        case from
        case createdAt = "created_at"
        case subject
        case html
        case text
        case headers
        case bcc
        case cc
        case replyTo = "reply_to"
        case messageId = "message_id"
        case attachments
    }
}

public struct ReceivedEmailListResponse: Decodable {
    public var hasMore: Bool
    public var data: [ReceivedEmailResponse]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
}

extension ReceivedEmailResponse {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        let toStrings = try container.decode([String].self, forKey: .to)
        to = toStrings.map { EmailAddress(from: $0) }
        
        let fromString = try container.decode(String.self, forKey: .from)
        from = EmailAddress(from: fromString)
        
        subject = try container.decode(String.self, forKey: .subject)
        html = try container.decodeIfPresent(String.self, forKey: .html)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        
        if let headersDict = try container.decodeIfPresent([String: String].self, forKey: .headers) {
            headers = headersDict.map { EmailHeaders(name: $0.key, value: $0.value) }
        } else {
            headers = nil
        }
        
        let bccStrings = try container.decode([String].self, forKey: .bcc)
        bcc = bccStrings.map { EmailAddress(from: $0) }
        
        let ccStrings = try container.decode([String].self, forKey: .cc)
        cc = ccStrings.map { EmailAddress(from: $0) }
        
        let replyToStrings = try container.decode([String].self, forKey: .replyTo)
        replyTo = replyToStrings.map { EmailAddress(from: $0) }
        
        messageId = try container.decode(String.self, forKey: .messageId)
        attachments = try container.decode([ReceivedAttachment].self, forKey: .attachments)
        
        if let dateString = try? container.decode(String.self, forKey: .createdAt) {
             if let date = DateFormatter.resendReceivedEmailDateFormatter.date(from: dateString) {
                 createdAt = date
             } else if let date = DateFormatter.iso8601Full.date(from: dateString) {
                 createdAt = date
             } else {
                 throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Date string does not match expected formats")
             }
        } else {
             createdAt = try container.decode(Date.self, forKey: .createdAt)
        }
    }
}

