import Foundation

public struct ContactTopicInput: Codable {
    public var id: String
    public var subscription: TopicSubscription
    
    public init(id: String, subscription: TopicSubscription) {
        self.id = id
        self.subscription = subscription
    }
}

struct ContactCreateGlobal: Encodable {
    var email: String
    var firstName: String?
    var lastName: String?
    var unsubscribed: Bool?
    var properties: [String: String]?
    var segments: [String]?
    var topics: [ContactTopicInput]?
    
    init(email: String,
         firstName: String? = nil,
         lastName: String? = nil,
         unsubscribed: Bool? = nil,
         properties: [String: String]? = nil,
         segments: [String]? = nil,
         topics: [ContactTopicInput]? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.unsubscribed = unsubscribed
        self.properties = properties
        self.segments = segments
        self.topics = topics
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case unsubscribed
        case properties
        case segments
        case topics
    }
}
