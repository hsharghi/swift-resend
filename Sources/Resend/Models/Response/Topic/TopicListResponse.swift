import Foundation

public struct TopicListResponse: Decodable {
    public var hasMore: Bool
    public var data: [Topic]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
}
