import Foundation

struct ContactUpdateGlobal: Encodable {
    var email: String?
    var firstName: String?
    var lastName: String?
    var unsubscribed: Bool?
    var properties: [String: String]?
    
    init(email: String? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         unsubscribed: Bool? = nil,
         properties: [String: String]? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.unsubscribed = unsubscribed
        self.properties = properties
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case unsubscribed
        case properties
    }
}
