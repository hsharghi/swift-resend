//
//  EmailSchedule.swift
//  swift-resend
//
//  Created by Hadi Sharghi on 7/2/25.
//

import Foundation

public enum EmailSchedule {
    case date(Date)
    case string(String)
}

extension EmailSchedule: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}


// Custom Codable implementation
extension EmailSchedule: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .date(let date):
            // Encode Date as ISO 8601 string
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            try container.encode(formatter.string(from: date))
        case .string(let string):
            // Encode String directly
            try container.encode(string)
        }
    }
}
