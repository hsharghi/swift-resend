import Foundation

public struct BroadcastListResponse: Decodable {
    public var data: [BroadcastSummary]
}

public struct BroadcastSummary: Decodable {
    public var id: String
    public var audienceId: String
    public var status: String
    public var createdAt: Date
    public var scheduledAt: EmailSchedule?
    public var sentAt: Date?

    private enum CodingKeys: String, CodingKey {
        case id
        case audienceId = "audience_id"
        case status
        case createdAt = "created_at"
        case scheduledAt = "scheduled_at"
        case sentAt = "sent_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        audienceId = try container.decode(String.self, forKey: .audienceId)
        status = try container.decode(String.self, forKey: .status)

        createdAt = try Self.decodeDate(from: container, forKey: .createdAt)

        scheduledAt = try container.decodeIfPresent(EmailSchedule.self, forKey: .scheduledAt)

        // decodeIfPresent already returns String? — no double-optional needed
        if let sentAtString = try container.decodeIfPresent(String.self, forKey: .sentAt) {
            sentAt = try Self.parseDate(from: sentAtString, container: container, key: .sentAt)
        } else {
            sentAt = nil
        }
    }

    private static let spaceSeparatedFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        return f
    }()

    private static let isoFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        return f
    }()

    private static func decodeDate(
        from container: KeyedDecodingContainer<CodingKeys>,
        forKey key: CodingKeys
    ) throws -> Date {
        if let dateString = try? container.decode(String.self, forKey: key) {
            return try parseDate(from: dateString, container: container, key: key)
        }
        return try container.decode(Date.self, forKey: key)
    }

    private static func parseDate(
        from string: String,
        container: KeyedDecodingContainer<CodingKeys>,
        key: CodingKeys
    ) throws -> Date {
        if let date = spaceSeparatedFormatter.date(from: string) { return date }
        if let date = isoFormatter.date(from: string) { return date }
        throw DecodingError.dataCorruptedError(
            forKey: key,
            in: container,
            debugDescription: "Date string '\(string)' does not match expected formats"
        )
    }
}
