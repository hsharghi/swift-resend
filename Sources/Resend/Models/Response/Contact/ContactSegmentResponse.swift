import Foundation

public struct ContactSegmentMembership: Decodable {
    public var id: String
    public var name: String
    public var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
    }
}

public struct ContactSegmentListResponse: Decodable {
    public var hasMore: Bool
    public var data: [ContactSegmentMembership]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
}

public struct ContactSegmentResponse: Decodable {
    /// Contact ID.
    public var id: String
    /// Segment ID. The API currently returns this as `audienceId`.
    public var audienceId: String?
    public var deleted: Bool?
    
    /// Preferred alias for the segment ID.
    public var segmentId: String? { audienceId }
    
    enum CodingKeys: String, CodingKey {
        case id
        case audienceId
        case audienceIdSnake = "audience_id"
        case segmentId = "segment_id"
        case contactId = "contact_id"
        case deleted
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let contactId = try container.decodeIfPresent(String.self, forKey: .contactId) {
            id = contactId
        } else {
            id = try container.decode(String.self, forKey: .id)
        }
        audienceId = try container.decodeIfPresent(String.self, forKey: .audienceId)
            ?? container.decodeIfPresent(String.self, forKey: .audienceIdSnake)
            ?? container.decodeIfPresent(String.self, forKey: .segmentId)
        deleted = try container.decodeIfPresent(Bool.self, forKey: .deleted)
    }
}
