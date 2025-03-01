import Foundation

struct DomainUpdate: Encodable {
    var clickTracking: Bool
    var openTracking: Bool
    var tls: String
    
    enum CodingKeys: String, CodingKey {
        case clickTracking = "click_tracking"
        case openTracking = "open_tracking"
        case tls
    }
} 