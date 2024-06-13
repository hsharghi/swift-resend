//
//  File.swift
//
//
//  Created by Hadi Sharghi on 2024-06-10.
//

import Foundation

public struct ResendContact {
    
    /// The Contact ID.
    public var id: String
    /// The email address of the contact.
    public var email: String
    /// The first name of the contact.
    public var firstName: String?
    /// The last name of the contact.
    public var lastName: String?
    /// The subscription status.
    public var subscriptionStatus: Bool
    /// Created date of the contact
    public var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case subscriptionStatus = "unsubscribed"
        case createdAt = "created_at"
    }
    
}


extension ResendContact: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String?.self, forKey: .firstName)
        lastName = try container.decode(String?.self, forKey: .lastName)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        let unsubscribed = try container.decode(Bool.self, forKey: .subscriptionStatus)
        subscriptionStatus = !unsubscribed
        
    }
}
