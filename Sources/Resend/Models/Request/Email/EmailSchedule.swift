//
//  EmailSchedule.swift
//  swift-resend
//
//  Created by Hadi Sharghi on 7/2/25.
//

import Foundation

/// Type of email schedule.
/// It can be a `Date` object or just a string in natural language.
/// e.g. "in an hour"
public enum EmailSchedule {
    case date(Date)
    case string(String)
}

extension EmailSchedule: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}


/// Custom Codable implementation to convert `Date` object to proper date format
/// Date format shoudl be ISO 8601
extension EmailSchedule: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Try to decode as Date first
        if let date = try? container.decode(Date.self) {
            self = .date(date)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected Date or String for EmailSchedule")
        }
    }
    
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
