import Foundation

public enum SuppressionOrigin: String, Codable {
    case bounce
    case complaint
    case manual
}

struct SuppressionAdd: Encodable {
    var email: String
    
    init(email: String) {
        self.email = email
    }
}

struct SuppressionBatchAdd: Encodable {
    var emails: [String]
    
    init(emails: [String]) {
        self.emails = emails
    }
}

struct SuppressionBatchRemove: Encodable {
    var emails: [String]?
    var ids: [String]?
    
    init(emails: [String]? = nil, ids: [String]? = nil) {
        self.emails = emails
        self.ids = ids
    }
}
