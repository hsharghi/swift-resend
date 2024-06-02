import Foundation

public struct EmailSentResponse: Codable {
    
    /// Id of the sent email.
    /// Id is a UUID string
    /// The sent email can be retrieved later using this Id
    public var id: String?
    public var error: ErrorResponse?
    
    init(id: String? = nil, error: ErrorResponse? = nil) {
        self.id = id
        self.error = error
    }
}
