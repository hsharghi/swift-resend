import Foundation

public enum ContactPropertyType: String, Codable {
    case string
    case number
}

/// String or number fallback value for a contact property.
public enum ContactPropertyValue: Codable, Equatable {
    case string(String)
    case number(Double)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else {
            throw DecodingError.typeMismatch(
                ContactPropertyValue.self,
                .init(codingPath: decoder.codingPath, debugDescription: "Expected string or number")
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
        }
    }
}

struct ContactPropertyCreate: Encodable {
    
    var key: String
    var type: ContactPropertyType
    var fallbackValue: ContactPropertyValue?
    
    init(key: String, type: ContactPropertyType, fallbackValue: ContactPropertyValue? = nil) {
        self.key = key
        self.type = type
        self.fallbackValue = fallbackValue
    }
    
    enum CodingKeys: String, CodingKey {
        case key
        case type
        case fallbackValue = "fallback_value"
    }
}

struct ContactPropertyUpdate: Encodable {
    
    var fallbackValue: ContactPropertyValue?
    
    init(fallbackValue: ContactPropertyValue?) {
        self.fallbackValue = fallbackValue
    }
    
    enum CodingKeys: String, CodingKey {
        case fallbackValue = "fallback_value"
    }
}
