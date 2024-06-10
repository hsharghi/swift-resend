//
//  File.swift
//
//
//  Created by Hadi Sharghi on 2024-06-10.
//

import Foundation

public struct ResendContact: Decodable {
    /// The email address of the contact.
    public var email: String
    /// The first name of the contact.
    public var firstName: String
    /// The last name of the contact.
    public var lastName: String
    /// The subscription status.
    public var unsubscribed: Bool
    /// The Audience ID.
    public var audienceId: String
    /// Created date of the contact
    public var createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case unsubscribed
        case audienceId = "audience_id"
        case createdAt = "create_at"
    }
    
    init(email: String,
         firstName: String,
         lastName: String,
         unsubscribed: Bool,
         audienceId: String,
         createdAt: Date? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.unsubscribed = unsubscribed
        self.audienceId = audienceId
        self.createdAt = createdAt
    }
}
