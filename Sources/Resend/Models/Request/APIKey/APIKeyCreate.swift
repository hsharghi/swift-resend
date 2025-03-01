import Foundation

struct APIKeyCreate: Encodable {
    var name: String
    var permission: String
    var domainId: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case permission
        case domainId = "domain_id"
    }
} 