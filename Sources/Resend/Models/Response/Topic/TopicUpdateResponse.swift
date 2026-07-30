import Foundation

public struct TopicUpdateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}
