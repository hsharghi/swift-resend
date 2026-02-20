//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/9/24.
//

import Foundation

public struct EmailListItem {

    public var id: String
    public var to: [EmailAddress]
    public var from: EmailAddress
    public var createdAt: Date
    public var subject: String
    public var bcc: [EmailAddress]?
    public var cc: [EmailAddress]?
    public var replyTo: [EmailAddress]?
    public var scheduledAt: EmailSchedule?

    enum CodingKeys: String, CodingKey {
        case id
        case to
        case from
        case createdAt = "created_at"
        case subject
        case bcc
        case cc
        case replyTo = "reply_to"
        case scheduledAt = "scheduled_at"
    }
    
}

public struct EmailListResponse: Decodable {

    public var hasMore: Bool
    public var data: [EmailListItem]

    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
}


extension EmailListItem: Decodable {
    
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
        
        if let scheduledAtString = try container.decode(String?.self, forKey: .scheduledAt) {
            scheduledAt = EmailSchedule(stringLiteral: scheduledAtString)
        }
        
    }
}
