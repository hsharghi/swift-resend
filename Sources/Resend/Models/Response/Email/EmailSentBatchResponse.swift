import Foundation

public struct EmailSentBatchResponse: Codable {
    
    /// Array of Ids of the sent emails.
    public var data: [EmailSentResponse]
    
    init(data: [EmailSentResponse]) {
        self.data = data
    }
}
