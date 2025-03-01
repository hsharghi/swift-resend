import Foundation

public struct DomainListResponse: Decodable {
    public var data: [Domain]
}

public struct Domain: Decodable {
    public var id: String
    public var name: String
    public var status: String
    public var createdAt: Date
    public var region: String
    public var records: [DomainRecord]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case createdAt = "created_at"
        case region
        case records
    }
}

public struct DomainRecord: Decodable {
    public var record: String
    public var name: String
    public var type: String
    public var ttl: String
    public var status: String
    public var value: String
    public var priority: Int?
} 