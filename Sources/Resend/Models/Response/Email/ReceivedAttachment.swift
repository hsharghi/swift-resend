import Foundation

public struct ReceivedAttachment: Codable {
    public var id: String
    public var filename: String
    public var size: UInt64?
    public var contentType: String
    public var contentDisposition: String
    public var contentId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case filename
        case size
        case contentType = "content_type"
        case contentDisposition = "content_disposition"
        case contentId = "content_id"
    }
}
