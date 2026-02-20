//
//  EmailGetResponse.swift
//
//
//  Created by Hadi Sharghi on 6/9/24.
//

import Foundation

public struct EmailGetResponse {
    
    public var id: String
    public var to: [EmailAddress]
    public var from: EmailAddress
    public var createdAt: Date
    public var subject: String
    public var html: String?
    public var text: String?
    public var bcc: [EmailAddress]?
    public var cc: [EmailAddress]?
    public var replyTo: [EmailAddress]?
    public var lastEvent: EmailEvents

    enum CodingKeys: String, CodingKey {
        case id
        case to
        case from
        case createdAt = "created_at"
        case subject
        case html
        case text
        case bcc
        case cc
        case replyTo = "reply_to"
        case lastEvent = "last_event"
    }
    
}


extension EmailGetResponse: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        let toStrings = try container.decode([String].self, forKey: .to)
        to = toStrings.map { EmailAddress(from: $0) }
        
        let fromString = try container.decode(String.self, forKey: .from)
        from = EmailAddress(from: fromString)
        
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        
        subject = try container.decode(String.self, forKey: .subject)
        html = try container.decode(String?.self, forKey: .html)
        text = try container.decode(String?.self, forKey: .text)
        
        if let bccStrings = try container.decode([String]?.self, forKey: .bcc) {
            bcc = bccStrings.map { EmailAddress(from: $0) }
        }
        
        if let ccStrings = try container.decode([String]?.self, forKey: .cc) {
            cc = ccStrings.map { EmailAddress(from: $0) }
        }
        
        if let replyToStrings = try container.decode([String]?.self, forKey: .replyTo) {
            replyTo = replyToStrings.map { EmailAddress(from: $0) }
        }
        
        lastEvent = try container.decode(EmailEvents.self, forKey: .lastEvent)
    }
}
