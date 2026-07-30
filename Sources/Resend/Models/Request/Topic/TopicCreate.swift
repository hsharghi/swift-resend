import Foundation

public enum TopicSubscription: String, Codable {
    case optIn = "opt_in"
    case optOut = "opt_out"
}

public enum TopicVisibility: String, Codable {
    case `public`
    case `private`
}

struct TopicCreate: Encodable {
    
    var name: String
    var defaultSubscription: TopicSubscription
    var description: String?
    var visibility: TopicVisibility?
    
    init(name: String,
         defaultSubscription: TopicSubscription,
         description: String? = nil,
         visibility: TopicVisibility? = nil) {
        self.name = name
        self.defaultSubscription = defaultSubscription
        self.description = description
        self.visibility = visibility
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case defaultSubscription = "default_subscription"
        case description
        case visibility
    }
}
