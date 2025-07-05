import Foundation

public struct DomainDeleteResponse: Decodable {
    public var object: String
    public var id: String
    public var deleted: Bool
} 