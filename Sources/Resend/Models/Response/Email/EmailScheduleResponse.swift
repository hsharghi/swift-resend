import Foundation

public struct EmailScheduleResponse: Codable {
    
    /// Id of the sent email.
    /// Id is a UUID string
    /// The sent email can be retrieved later using this Id
    public var id: String
    
    /// Object type
    /// object is a string
    public var object: String
    
    init(id: String, object: String? = nil) {
        self.id = id
        self.object = "email"
    }
}
