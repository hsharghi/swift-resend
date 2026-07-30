import Foundation

public struct SegmentListResponse: Decodable {
    public var hasMore: Bool
    public var data: [Segment]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
}
