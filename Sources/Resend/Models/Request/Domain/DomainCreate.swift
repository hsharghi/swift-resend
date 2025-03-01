import Foundation

struct DomainCreate: Encodable {
    var name: String
    var region: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case region
    }
} 