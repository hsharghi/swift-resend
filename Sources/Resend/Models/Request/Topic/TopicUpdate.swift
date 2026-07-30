import Foundation

struct TopicUpdate: Encodable {
    
    var name: String?
    var description: String?
    var visibility: TopicVisibility?
    
    init(name: String? = nil,
         description: String? = nil,
         visibility: TopicVisibility? = nil) {
        self.name = name
        self.description = description
        self.visibility = visibility
    }
}
