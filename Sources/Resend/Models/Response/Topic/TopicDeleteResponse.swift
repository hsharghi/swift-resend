import Foundation

public struct TopicDeleteResponse: Decodable {
    public var id: String
    public var deleted: Bool

    init(id: String, deleted: Bool) {
        self.id = id
        self.deleted = deleted
    }
}
