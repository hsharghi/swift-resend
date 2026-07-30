import Foundation

public struct ContactRemoveResponse: Decodable {
    public var contact: String
    public var deleted: Bool
    
    init(contact: String, deleted: Bool) {
        self.contact = contact
        self.deleted = deleted
    }
}
