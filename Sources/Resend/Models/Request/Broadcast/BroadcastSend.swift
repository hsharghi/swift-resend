//
//  BroadcastSend.swift
//  swift-resend
//
//  Created by Hadi Sharghi on 2/22/26.
//


import Foundation

internal struct BroadcastSend: Encodable {
    
    /// Schedule broadcast for later. The date should be in natural language (e.g.: in 1 min) or ISO 8601 format (e.g: 2024-08-05T11:52:01.858Z).
    public var scheduledAt: EmailSchedule
    
    public init(scheduledAt: EmailSchedule)
    {
        self.scheduledAt = scheduledAt
    }
    
    private enum CodingKeys: String, CodingKey {
        case scheduledAt = "scheduled_at"
    }

}
