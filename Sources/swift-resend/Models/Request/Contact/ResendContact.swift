//
//  File.swift
//
//
//  Created by Hadi Sharghi on 2024-06-10.
//

import Foundation

public struct ResendContact: Decodable {
    public var object: String
    public var email: String
    public var firstName: String
    public var lastName: String
    public var unsubscribed: Bool
    public var audienceId: String
    public var createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case object
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case unsubscribed
        case audienceId = "audience_id"
        case createdAt = "create_at"
    }
}
