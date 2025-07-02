//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 6/2/24.
//

import Foundation

public struct ResendEmail {
    
    public var from: EmailAddress

    /// An array of recipients. Each object within this array may contain the name, but must always contain the email, of a recipient.
    public var to: [EmailAddress]

    /// The global, or “message level”, subject of your email. This may be overridden by personalizations[x].subject.
    public var subject: String
    
    /// An array of recipients who will receive a copy of your email. Each object within this array may contain the name, but must always contain the email, of a recipient.
    public var cc: [EmailAddress]?

    /// An array of recipients who will receive a blind carbon copy of your email. Each object within this array may contain the name, but must always contain the email, of a recipient.
    public var bcc: [EmailAddress]?

    /// Schedule email to be sent later. The date should be in natural language (e.g.: in 1 min) or ISO 8601 format (e.g: 2024-08-05T11:52:01.858Z).
    public var scheduledAt: EmailSchedule?
    
    /// An array of recipients who will receive replies and/or bounces.
    public var replyTo: [EmailAddress]?
    
    /// The plain text version of the message.
    public var text: String?

    /// The HTML version of the message.
    public var html: String?
    
    /// Custom headers to add to the email.
    public var headers: [EmailHeaders]?

    /// An array of objects in which you can specify any attachments you want to include.
    public var attachments: [EmailAttachment]?
    
    /// An array of objects in which you can specify any attachments you want to include.
    public var tags: [EmailTags]?
    
    public init(from: EmailAddress, 
         to: [EmailAddress],
         subject: String,
         cc: [EmailAddress]? = nil,
         bcc: [EmailAddress]? = nil,
         scheduledAt: EmailSchedule? = nil,
         replyTo: [EmailAddress]? = nil,
         text: String? = nil,
         html: String? = nil,
         headers: [EmailHeaders]? = nil,
         attachments: [EmailAttachment]? = nil,
         tags: [EmailTags]? = nil) {
        self.from = from
        self.to = to
        self.subject = subject
        self.cc = cc
        self.bcc = bcc
        self.scheduledAt = scheduledAt
        self.replyTo = replyTo
        self.text = text
        self.html = html
        self.headers = headers
        self.attachments = attachments
        self.tags = tags
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case from
        case to
        case subject
        case cc
        case bcc
        case scheduledAt = "scheduled_at"
        case replyTo = "reply_to"
        case text
        case html
        case headers
        case attachments
        case tags
    }

}


extension ResendEmail: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(from.string, forKey: .from)
        try container.encodeIfPresent(to.stringArray, forKey: .to)
        try container.encodeIfPresent(subject, forKey: .subject)
        try container.encodeIfPresent(cc?.stringArray, forKey: .cc)
        try container.encodeIfPresent(bcc?.stringArray, forKey: .bcc)
        try container.encodeIfPresent(scheduledAt, forKey: .scheduledAt)
        try container.encodeIfPresent(replyTo?.stringArray, forKey: .replyTo)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(html, forKey: .html)
        try container.encodeIfPresent(headers?.objectArray, forKey: .headers)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(tags, forKey: .tags)
    }
}
