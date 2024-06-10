import Foundation
import NIOCore

/// Filename and content of attachments (max 40mb per email)
public struct EmailAttachment {
    
    /// The Base64 encoded content of the attachment.
    public var content: ByteBuffer?
    
    /// The filename of the attachment.
    public var filename: String
    
    /// Path where the attachment file is hosted
    public var path: String?

    init(content: ByteBuffer,
         filename: String,
         path: String? = nil) {
        self.content = content
        self.filename = filename
        self.path = path
    }

    enum CodingKeys: CodingKey {
        case content
        case filename
        case path
    }
}

extension EmailAttachment: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(filename, forKey: .filename)
        try container.encodeIfPresent(content, forKey: .content)
        try container.encodeIfPresent(path, forKey: .path)
    }
}
