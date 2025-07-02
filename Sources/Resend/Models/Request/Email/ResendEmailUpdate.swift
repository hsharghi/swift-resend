//
//  EmailUpdate.swift
//  swift-resend
//
//  Created by Hadi Sharghi on 7/2/25.
//


import Foundation

internal struct ResendEmailUpdate: Encodable {
    
    /// Id of the email to update the schedule
    /// Id is a UUID string
    /// The sent email can be retrieved later using this Id
    public var id: String

    /// Schedule email to be sent later. The date should be in natural language (e.g.: in 1 min) or ISO 8601 format (e.g: 2024-08-05T11:52:01.858Z).
    public var scheduledAt: EmailSchedule
    
    public init(id: String, scheduledAt: EmailSchedule)
    {
        self.id = id
        self.scheduledAt = scheduledAt
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case scheduledAt = "scheduled_at"
    }

}
