import Foundation

public enum TemplateVariableType: String, Codable {
    case string
    case number
}

public enum TemplateStatus: String, Codable {
    case draft
    case published
}

/// String or number value used for template variable fallbacks and send-time variables.
public enum TemplateVariableValue: Codable, Equatable {
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
                TemplateVariableValue.self,
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

public struct TemplateVariableInput: Codable, Equatable {
    public var key: String
    public var type: TemplateVariableType
    public var fallbackValue: TemplateVariableValue?
    
    public init(key: String, type: TemplateVariableType, fallbackValue: TemplateVariableValue? = nil) {
        self.key = key
        self.type = type
        self.fallbackValue = fallbackValue
    }
    
    public static func string(_ key: String, fallback: String? = nil) -> TemplateVariableInput {
        TemplateVariableInput(
            key: key,
            type: .string,
            fallbackValue: fallback.map { .string($0) }
        )
    }
    
    public static func number(_ key: String, fallback: Double? = nil) -> TemplateVariableInput {
        TemplateVariableInput(
            key: key,
            type: .number,
            fallbackValue: fallback.map { .number($0) }
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case key
        case type
        case fallbackValue = "fallback_value"
    }
}

struct TemplateCreate: Encodable {
    
    var name: String
    var html: String
    var alias: String?
    var from: String?
    var subject: String?
    var replyTo: [String]?
    var text: String?
    var variables: [TemplateVariableInput]?
    
    init(name: String,
         html: String,
         alias: String? = nil,
         from: EmailAddress? = nil,
         subject: String? = nil,
         replyTo: [EmailAddress]? = nil,
         text: String? = nil,
         variables: [TemplateVariableInput]? = nil) {
        self.name = name
        self.html = html
        self.alias = alias
        self.from = from?.string
        self.subject = subject
        self.replyTo = replyTo?.stringArray
        self.text = text
        self.variables = variables
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case html
        case alias
        case from
        case subject
        case replyTo = "reply_to"
        case text
        case variables
    }
}

struct TemplateUpdate: Encodable {
    
    var name: String?
    var html: String?
    var alias: String?
    var from: String?
    var subject: String?
    var replyTo: [String]?
    var text: String?
    var variables: [TemplateVariableInput]?
    
    init(name: String? = nil,
         html: String? = nil,
         alias: String? = nil,
         from: EmailAddress? = nil,
         subject: String? = nil,
         replyTo: [EmailAddress]? = nil,
         text: String? = nil,
         variables: [TemplateVariableInput]? = nil) {
        self.name = name
        self.html = html
        self.alias = alias
        self.from = from?.string
        self.subject = subject
        self.replyTo = replyTo?.stringArray
        self.text = text
        self.variables = variables
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case html
        case alias
        case from
        case subject
        case replyTo = "reply_to"
        case text
        case variables
    }
}

/// Reference to a published template when sending an email.
public struct EmailTemplate: Encodable, Equatable {
    public var id: String
    public var variables: [String: TemplateVariableValue]?
    
    public init(id: String, variables: [String: TemplateVariableValue]? = nil) {
        self.id = id
        self.variables = variables
    }
}
