import Foundation

public struct ContactListGlobalResponse: Decodable {
    public var hasMore: Bool
    public var data: [Contact]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        data = try container.decode([Contact].self, forKey: .data)
    }
}
