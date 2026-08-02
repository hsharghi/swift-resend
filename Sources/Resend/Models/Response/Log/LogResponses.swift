import Foundation

public enum LogHTTPMethod: String, Codable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case options = "OPTIONS"
}

/// Arbitrary JSON value used for log request/response bodies.
public enum JSONValue: Codable, Equatable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case object([String: JSONValue])
    case array([JSONValue])
    case null
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else if let object = try? container.decode([String: JSONValue].self) {
            self = .object(object)
        } else if let array = try? container.decode([JSONValue].self) {
            self = .array(array)
        } else {
            throw DecodingError.typeMismatch(
                JSONValue.self,
                .init(codingPath: decoder.codingPath, debugDescription: "Unsupported JSON value")
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

public struct LogSummary: Decodable {
    public var id: String
    public var createdAt: Date
    public var endpoint: String
    public var method: LogHTTPMethod
    public var responseStatus: Int
    public var userAgent: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case endpoint
        case method
        case responseStatus = "response_status"
        case userAgent = "user_agent"
    }
}

public struct Log: Decodable {
    public var id: String
    public var createdAt: Date
    public var endpoint: String
    public var method: LogHTTPMethod
    public var responseStatus: Int
    public var userAgent: String?
    public var requestBody: [String: JSONValue]?
    public var responseBody: [String: JSONValue]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case endpoint
        case method
        case responseStatus = "response_status"
        case userAgent = "user_agent"
        case requestBody = "request_body"
        case responseBody = "response_body"
    }
}

public struct LogListResponse: Decodable {
    public var hasMore: Bool
    public var data: [LogSummary]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false
        data = try container.decode([LogSummary].self, forKey: .data)
    }
}
