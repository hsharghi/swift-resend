import Foundation

public struct BroadcastCreateResponse: Decodable {
    /// Id of the created broadcast.
    public var id: String

    public init(id: String) {
        self.id = id
    }
} 