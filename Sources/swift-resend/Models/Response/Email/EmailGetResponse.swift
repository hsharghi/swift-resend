//
//  File.swift
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
    public var lastEvent: String

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
    
    init(id: String, 
         to: [EmailAddress],
         from: EmailAddress,
         createdAt: Date,
         subject: String,
         html: String? = nil,
         text: String? = nil,
         bcc: [EmailAddress]? = nil,
         cc: [EmailAddress]? = nil,
         replyTo: [EmailAddress]? = nil,
         lastEvent: String) {
        self.id = id
        self.to = to
        self.from = from
        self.createdAt = createdAt
        self.subject = subject
        self.html = html
        self.text = text
        self.bcc = bcc
        self.cc = cc
        self.replyTo = replyTo
        self.lastEvent = lastEvent
    }
}


extension EmailGetResponse: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        let toStrings = try container.decode([String].self, forKey: .to)
        let toAddresses = toStrings.map { EmailAddress(from: $0)}
        to = toAddresses
        
        let fromString = try container.decode(String.self, forKey: .from)
        from = EmailAddress(from: fromString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        
        subject = try container.decode(String.self, forKey: .subject)
        html = try container.decode(String?.self, forKey: .html)
        text = try container.decode(String?.self, forKey: .text)
        
        if let bccStrings = try container.decode([String]?.self, forKey: .bcc) {
            let bccAddresses = bccStrings.map { EmailAddress(from: $0)}
            bcc = bccAddresses
        }
        
        if let ccStrings = try container.decode([String]?.self, forKey: .cc) {
            let ccAddresses = ccStrings.map { EmailAddress(from: $0)}
            cc = ccAddresses
        }
        
        if let replyToString = try container.decode([String]?.self, forKey: .replyTo) {
            let replyToAddresses = replyToString.map { EmailAddress(from: $0)}
            replyTo = replyToAddresses
        }
        
        lastEvent = try container.decode(String.self, forKey: .lastEvent)

        
    }
}
