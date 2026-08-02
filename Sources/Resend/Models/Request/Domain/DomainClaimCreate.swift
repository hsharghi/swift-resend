import Foundation

struct DomainClaimCreate: Encodable {
    
    var name: String
    var region: String?
    var customReturnPath: String?
    var openTracking: Bool?
    var clickTracking: Bool?
    var trackingSubdomain: String?
    
    init(name: String,
         region: String? = nil,
         customReturnPath: String? = nil,
         openTracking: Bool? = nil,
         clickTracking: Bool? = nil,
         trackingSubdomain: String? = nil) {
        self.name = name
        self.region = region
        self.customReturnPath = customReturnPath
        self.openTracking = openTracking
        self.clickTracking = clickTracking
        self.trackingSubdomain = trackingSubdomain
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case region
        case customReturnPath = "custom_return_path"
        case openTracking = "open_tracking"
        case clickTracking = "click_tracking"
        case trackingSubdomain = "tracking_subdomain"
    }
}
