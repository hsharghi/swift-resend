import Foundation

public struct OAuthGrantClientInfo: Decodable, Equatable {
    /// The name of the OAuth client.
    public var name: String
    /// The URL of the OAuth client's logo.
    public var logoUri: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case logoUri = "logo_uri"
    }
}

public struct OAuthGrant: Decodable, Equatable {
    /// The ID of the OAuth grant.
    public var id: String
    /// The ID of the OAuth client the grant was issued to.
    public var clientId: String
    /// The scopes granted to the OAuth client.
    public var scopes: [String]
    /// Optional resource indicator for the grant.
    public var resource: String?
    /// The date and time the OAuth grant was created.
    public var createdAt: Date
    /// The date and time the OAuth grant was revoked, or `nil` if still active.
    public var revokedAt: Date?
    /// The reason the OAuth grant was revoked, or `nil` if still active.
    public var revokedReason: String?
    /// The OAuth client the grant was issued to.
    public var client: OAuthGrantClientInfo
    
    enum CodingKeys: String, CodingKey {
        case id
        case clientId = "client_id"
        case scopes
        case resource
        case createdAt = "created_at"
        case revokedAt = "revoked_at"
        case revokedReason = "revoked_reason"
        case client
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        clientId = try container.decode(String.self, forKey: .clientId)
        scopes = try container.decode([String].self, forKey: .scopes)
        resource = try container.decodeIfPresent(String.self, forKey: .resource)
        createdAt = try Self.decodeDate(from: container, forKey: .createdAt)
        if let revokedAtString = try container.decodeIfPresent(String.self, forKey: .revokedAt) {
            revokedAt = try Self.parseDate(from: revokedAtString, container: container, key: .revokedAt)
        } else {
            revokedAt = nil
        }
        revokedReason = try container.decodeIfPresent(String.self, forKey: .revokedReason)
        client = try container.decode(OAuthGrantClientInfo.self, forKey: .client)
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

public struct OAuthGrantListResponse: Decodable {
    public var hasMore: Bool
    public var data: [OAuthGrant]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        data = try container.decode([OAuthGrant].self, forKey: .data)
    }
}

public struct OAuthGrantRevokeResponse: Decodable, Equatable {
    public var object: String?
    /// The ID of the OAuth grant.
    public var id: String
    /// The date and time the OAuth grant was revoked.
    public var revokedAt: Date
    /// The reason the OAuth grant was revoked.
    public var revokedReason: String
    
    enum CodingKeys: String, CodingKey {
        case object
        case id
        case revokedAt = "revoked_at"
        case revokedReason = "revoked_reason"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decodeIfPresent(String.self, forKey: .object)
        id = try container.decode(String.self, forKey: .id)
        revokedReason = try container.decode(String.self, forKey: .revokedReason)
        
        if let revokedAtString = try? container.decode(String.self, forKey: .revokedAt) {
            revokedAt = try OAuthGrant.parseRevokeDate(from: revokedAtString, container: container)
        } else {
            revokedAt = try container.decode(Date.self, forKey: .revokedAt)
        }
    }
}

private extension OAuthGrant {
    static func parseRevokeDate(
        from string: String,
        container: KeyedDecodingContainer<OAuthGrantRevokeResponse.CodingKeys>
    ) throws -> Date {
        if let date = spaceSeparatedFormatter.date(from: string) { return date }
        if let date = isoFormatter.date(from: string) { return date }
        if let date = isoFormatterNoFractional.date(from: string) { return date }
        throw DecodingError.dataCorruptedError(
            forKey: .revokedAt,
            in: container,
            debugDescription: "Date string '\(string)' does not match expected formats"
        )
    }
}
