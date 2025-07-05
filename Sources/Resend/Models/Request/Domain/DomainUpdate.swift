import Foundation

public enum DomainTLSMode: String, Codable {
    case opportunistic
    case enforced
}

struct DomainUpdate: Encodable {
    var clickTracking: Bool
    var openTracking: Bool
    var tls: DomainTLSMode
    
    enum CodingKeys: String, CodingKey {
        case clickTracking = "click_tracking"
        case openTracking = "open_tracking"
        case tls
    }
} 