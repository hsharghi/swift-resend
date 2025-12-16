//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/9/24.
//

import Foundation

public struct EmailAttachmentItem {
    
    public var id: String
    public var filename: String
    public var size: UInt64
    public var contentType: String
    public var contentDisposition: String
    public var contentId: String
    public var downloadUrl: String
    public var expiresAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case filename
        case size
        case contentType = "content_type"
        case contentDisposition = "content_disposition"
        case contentId = "content_id"
        case downloadUrl = "download_url"
        case expiresAt = "expires_at"
    }
    
}

public struct EmailAttachmentResponse: Decodable {
    public var hasMore: Bool
    public var data: [EmailAttachmentItem]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
}


extension EmailAttachmentItem: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        filename = try container.decode(String.self, forKey: .filename)
        size = try container.decode(UInt64.self, forKey: .size)
        contentType = try container.decode(String.self, forKey: .contentType)
        contentDisposition = try container.decode(String.self, forKey: .contentDisposition)
        contentId = ""
        if let decodedContentId = try container.decodeIfPresent(String.self, forKey: .contentId) {
            contentId = decodedContentId
        }
        downloadUrl = try container.decode(String.self, forKey: .downloadUrl)
        
        if let dateString = try? container.decode(String.self, forKey: .expiresAt) {
             if let date = DateFormatter.resendReceivedEmailDateFormatter.date(from: dateString) {
                 expiresAt = date
             } else if let date = DateFormatter.iso8601Full.date(from: dateString) {
                 expiresAt = date
             } else {
                 throw DecodingError.dataCorruptedError(forKey: .expiresAt, in: container, debugDescription: "Date string does not match expected formats")
             }
        } else {
            expiresAt = try container.decode(Date.self, forKey: .expiresAt)
        }

    }
}
