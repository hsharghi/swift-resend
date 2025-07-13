import Foundation
import NIOCore

/// Filename and content of attachments (max 40mb per email)
public struct EmailAttachment {
    
    /// Max attachment size
    static let maxSize: UInt64 = 40 * 1024 * 1024
    
    /// The Base64 encoded content of the attachment.
    public var content: ByteBuffer?
    
    /// The filename of the attachment.
    public var filename: String
    
    /// Path where the attachment file is hosted
    public var path: String?

    public init(content: ByteBuffer,
         filename: String,
         path: String? = nil) throws {
        
        // Check size limit
        let contentSize = UInt64(content.readableBytes)
        guard contentSize <= Self.maxSize else {
            throw ResendError.attachmentTooLarge(contentSize)
        }

        self.content = content
        self.filename = filename
        self.path = path
    }
    

    /// Initialize by loading content from a local file path
    /// - Parameter filePath: Absolute path to the file
    /// - Throws: `ResendError.attachmentTooLarge` if file exceeds 40MB or can't be read
    public init(filePath: String) throws {
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        // Check if file exists
        guard FileManager.default.fileExists(atPath: filePath) else {
            throw ResendError.invalidAttachment("Attachment file not found")
        }

        
        // Get file attributes to check size
        let attributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = attributes[.size] as? UInt64 else {
            throw ResendError.invalidAttachment("Invalid file attributes")
        }
        
        // Check size limit
        guard fileSize <= Self.maxSize else {
            throw ResendError.attachmentTooLarge(fileSize)
        }
        
        let data = try Data(contentsOf: fileURL)
        let buffer = ByteBuffer(data: data)
        
        self.content = buffer
        self.filename = fileURL.lastPathComponent
    }
    
    private enum CodingKeys: CodingKey {
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
