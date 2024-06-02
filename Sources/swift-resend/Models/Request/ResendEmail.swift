//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 6/2/24.
//

import Foundation

public struct ResendEmail: Codable {
    
    public var from: EmailAddress

    /// An array of recipients. Each object within this array may contain the name, but must always contain the email, of a recipient.
    public var to: [EmailAddress]?

    /// The global, or “message level”, subject of your email. This may be overridden by personalizations[x].subject.
    public var subject: String?
    
    /// An array of recipients who will receive a copy of your email. Each object within this array may contain the name, but must always contain the email, of a recipient.
    public var cc: [EmailAddress]?

    /// An array of recipients who will receive a blind carbon copy of your email. Each object within this array may contain the name, but must always contain the email, of a recipient.
    public var bcc: [EmailAddress]?

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
    
    init(from: EmailAddress, 
         to: [EmailAddress]? = nil,
         subject: String? = nil,
         cc: [EmailAddress]? = nil,
         bcc: [EmailAddress]? = nil,
         replyTo: [EmailAddress]? = nil,
         text: String? = nil,
         html: String? = nil,
         attachments: [EmailAttachment]? = nil,
         tags: [EmailTags]? = nil) {
        self.from = from
        self.to = to
        self.subject = subject
        self.cc = cc
        self.bcc = bcc
        self.replyTo = replyTo
        self.text = text
        self.html = html
        self.attachments = attachments
        self.tags = tags
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case from
        case to
        case subject
        case cc
        case bcc
        case replyTo = "reply_to"
        case text
        case html
        case attachments
        case tags
    }

}
