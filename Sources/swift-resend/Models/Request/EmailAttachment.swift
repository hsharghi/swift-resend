import Foundation

public struct EmailAttachment: Codable {
    
    /// The Base64 encoded content of the attachment.
    public var content: String
    
    /// The filename of the attachment.
    public var filename: String
    
    /// Path where the attachment file is hosted
    public var path: String?

    init(content: String, 
         filename: String,
         path: String? = nil) {
        self.content = content
        self.filename = filename
        self.path = path
    }
    
}
