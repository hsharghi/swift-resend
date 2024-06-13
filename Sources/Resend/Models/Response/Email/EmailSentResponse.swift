import Foundation

public struct EmailSentResponse: Codable {
    
    /// Id of the sent email.
    /// Id is a UUID string
    /// The sent email can be retrieved later using this Id
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}
