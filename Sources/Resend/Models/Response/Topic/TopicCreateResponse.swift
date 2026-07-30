import Foundation

public struct TopicCreateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}
