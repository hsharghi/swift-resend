import Foundation

public struct Topic: Decodable {
    public var id: String
    public var name: String
    public var description: String?
    public var defaultSubscription: TopicSubscription
    public var visibility: TopicVisibility?
    public var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case defaultSubscription = "default_subscription"
        case visibility
        case createdAt = "created_at"
    }
}
