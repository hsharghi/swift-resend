import Foundation

public struct SegmentCreateResponse: Decodable {
    public var id: String
    public var name: String?
    
    init(id: String, name: String? = nil) {
        self.id = id
        self.name = name
    }
}
