import Foundation

public struct ContactImportCounts: Decodable, Equatable {
    public var total: Int
    public var created: Int
    public var updated: Int
    public var skipped: Int
    public var failed: Int
}

public struct ContactImport: Decodable, Equatable {
    public var object: String?
    public var id: String
    public var status: ContactImportStatus
    public var createdAt: Date
    public var completedAt: Date?
    public var counts: ContactImportCounts
    
    enum CodingKeys: String, CodingKey {
        case object
        case id
        case status
        case createdAt = "created_at"
        case completedAt = "completed_at"
        case counts
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decodeIfPresent(String.self, forKey: .object)
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(ContactImportStatus.self, forKey: .status)
        createdAt = try Self.decodeDate(from: container, forKey: .createdAt)
        if let completedAtString = try container.decodeIfPresent(String.self, forKey: .completedAt) {
            completedAt = try Self.parseDate(from: completedAtString, container: container, key: .completedAt)
        } else {
            completedAt = nil
        }
        counts = try container.decode(ContactImportCounts.self, forKey: .counts)
    }
    
    private static let spaceSeparatedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        return formatter
    }()
    
    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private static let isoFormatterNoFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
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
        if let date = isoFormatterNoFractional.date(from: string) { return date }
        throw DecodingError.dataCorruptedError(
            forKey: key,
            in: container,
            debugDescription: "Date string '\(string)' does not match expected formats"
        )
    }
}

public struct ContactImportCreateResponse: Decodable, Equatable {
    public var object: String?
    public var id: String
}

public struct ContactImportListResponse: Decodable {
    public var hasMore: Bool
    public var data: [ContactImport]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        data = try container.decode([ContactImport].self, forKey: .data)
    }
}
