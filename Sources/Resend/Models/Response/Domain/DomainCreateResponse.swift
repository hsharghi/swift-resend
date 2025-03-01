import Foundation

public struct DomainCreateResponse: Decodable {
    public var id: String
    public var name: String
    public var createdAt: Date
    public var status: String
    public var records: [DomainRecord]
    public var region: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
        case status
        case records
        case region
    }
} 