import Foundation

public enum ContactImportOnConflict: String, Codable {
    case upsert
    case skip
}

public enum ContactImportPropertyType: String, Codable {
    case string
    case number
    case boolean
}

public enum ContactImportStatus: String, Codable {
    case queued
    case inProgress = "in_progress"
    case completed
    case failed
}

public struct ContactImportPropertyMapping: Encodable, Equatable {
    public var column: String
    public var type: ContactImportPropertyType?
    
    public init(column: String, type: ContactImportPropertyType? = nil) {
        self.column = column
        self.type = type
    }
}

/// Maps contact fields (and optional custom properties) to CSV column headers.
public struct ContactImportColumnMap: Encodable, Equatable {
    public var email: String?
    public var firstName: String?
    public var lastName: String?
    public var unsubscribed: String?
    public var properties: [String: ContactImportPropertyMapping]?
    
    public init(
        email: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        unsubscribed: String? = nil,
        properties: [String: ContactImportPropertyMapping]? = nil
    ) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.unsubscribed = unsubscribed
        self.properties = properties
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case unsubscribed
        case properties
    }
}

public struct ContactImportSegment: Encodable, Equatable {
    public var id: String
    
    public init(id: String) {
        self.id = id
    }
}

/// Options for creating a contact import (CSV upload).
public struct ContactImportCreate {
    /// CSV file contents. Maximum size is 50MB.
    public var fileData: Data
    /// Filename sent in the multipart part. Defaults to `contacts.csv`.
    public var filename: String
    public var columnMap: ContactImportColumnMap?
    /// How to handle contacts that already exist. Defaults to the API default when `nil`.
    public var onConflict: ContactImportOnConflict?
    public var segments: [ContactImportSegment]?
    public var topics: [ContactTopicInput]?
    
    public static let maxFileSize: UInt64 = 50 * 1024 * 1024
    
    public init(
        fileData: Data,
        filename: String = "contacts.csv",
        columnMap: ContactImportColumnMap? = nil,
        onConflict: ContactImportOnConflict? = nil,
        segments: [ContactImportSegment]? = nil,
        topics: [ContactTopicInput]? = nil
    ) throws {
        let size = UInt64(fileData.count)
        guard size <= Self.maxFileSize else {
            throw ResendError.validationError(
                "Contact import CSV exceeds the 50MB limit (\(size) bytes)."
            )
        }
        self.fileData = fileData
        self.filename = filename
        self.columnMap = columnMap
        self.onConflict = onConflict
        self.segments = segments
        self.topics = topics
    }
    
    /// Load CSV contents from a local file path.
    public init(
        filePath: String,
        columnMap: ContactImportColumnMap? = nil,
        onConflict: ContactImportOnConflict? = nil,
        segments: [ContactImportSegment]? = nil,
        topics: [ContactTopicInput]? = nil
    ) throws {
        let fileURL = URL(fileURLWithPath: filePath)
        guard FileManager.default.fileExists(atPath: filePath) else {
            throw ResendError.invalidAttachment("Contact import file not found")
        }
        let attributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = attributes[.size] as? UInt64 else {
            throw ResendError.invalidAttachment("Invalid contact import file attributes")
        }
        guard fileSize <= Self.maxFileSize else {
            throw ResendError.validationError(
                "Contact import CSV exceeds the 50MB limit (\(fileSize) bytes)."
            )
        }
        let data = try Data(contentsOf: fileURL)
        try self.init(
            fileData: data,
            filename: fileURL.lastPathComponent,
            columnMap: columnMap,
            onConflict: onConflict,
            segments: segments,
            topics: topics
        )
    }
    
    /// Convenience initializer that accepts segment IDs.
    public init(
        fileData: Data,
        filename: String = "contacts.csv",
        columnMap: ContactImportColumnMap? = nil,
        onConflict: ContactImportOnConflict? = nil,
        segmentIds: [String],
        topics: [ContactTopicInput]? = nil
    ) throws {
        try self.init(
            fileData: fileData,
            filename: filename,
            columnMap: columnMap,
            onConflict: onConflict,
            segments: segmentIds.map(ContactImportSegment.init(id:)),
            topics: topics
        )
    }
}
