import Foundation

public struct ContactTopic: Decodable {
    public var id: String
    public var name: String
    public var description: String?
    public var subscription: TopicSubscription
}

public struct ContactTopicListResponse: Decodable {
    public var hasMore: Bool
    public var data: [ContactTopic]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
}

public struct ContactTopicsUpdateResponse: Decodable {
    public var id: String
}
