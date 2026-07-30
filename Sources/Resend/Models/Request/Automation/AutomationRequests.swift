import Foundation

public enum AutomationStatus: String, Codable {
    case enabled
    case disabled
}

public enum AutomationStepType: String, Codable {
    case trigger
    case sendEmail = "send_email"
    case delay
    case waitForEvent = "wait_for_event"
    case condition
    case contactUpdate = "contact_update"
    case contactDelete = "contact_delete"
    case addToSegment = "add_to_segment"
}

public enum AutomationConnectionType: String, Codable {
    case `default`
    case conditionMet = "condition_met"
    case conditionNotMet = "condition_not_met"
    case timeout
    case eventReceived = "event_received"
}

public enum AutomationRunStatus: String, Codable {
    case running
    case completed
    case failed
    case cancelled
    case skipped
}

public struct AutomationConnection: Codable {
    public var from: String
    public var to: String
    public var type: AutomationConnectionType?
    
    public init(from: String, to: String, type: AutomationConnectionType? = nil) {
        self.from = from
        self.to = to
        self.type = type
    }
}

public struct AutomationConditionRule: Codable {
    public var type: String
    public var field: String?
    public var `operator`: String?
    public var value: String?
    public var rules: [AutomationConditionRule]?
    
    public init(type: String,
                field: String? = nil,
                operator: String? = nil,
                value: String? = nil,
                rules: [AutomationConditionRule]? = nil) {
        self.type = type
        self.field = field
        self.operator = `operator`
        self.value = value
        self.rules = rules
    }
}

public struct AutomationSendEmailTemplate: Codable {
    public var id: String
    public var variables: [String: String]?
    
    public init(id: String, variables: [String: String]? = nil) {
        self.id = id
        self.variables = variables
    }
}

public enum AutomationStepConfig: Codable {
    case trigger(eventName: String)
    case sendEmail(template: AutomationSendEmailTemplate, subject: String?, from: String?, replyTo: String?)
    case delay(duration: String)
    case waitForEvent(eventName: String, timeout: String?)
    case condition(AutomationConditionRule)
    case contactUpdate(firstName: String?, lastName: String?, unsubscribed: Bool?)
    case contactDelete
    case addToSegment(segmentId: String)
    
    enum CodingKeys: String, CodingKey {
        case eventName = "event_name"
        case template
        case subject
        case from
        case replyTo = "reply_to"
        case duration
        case timeout
        case firstName = "first_name"
        case lastName = "last_name"
        case unsubscribed
        case segmentId = "segment_id"
        case type
        case field
        case `operator`
        case value
        case rules
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .trigger(let eventName):
            try container.encode(eventName, forKey: .eventName)
        case .sendEmail(let template, let subject, let from, let replyTo):
            try container.encode(template, forKey: .template)
            try container.encodeIfPresent(subject, forKey: .subject)
            try container.encodeIfPresent(from, forKey: .from)
            try container.encodeIfPresent(replyTo, forKey: .replyTo)
        case .delay(let duration):
            try container.encode(duration, forKey: .duration)
        case .waitForEvent(let eventName, let timeout):
            try container.encode(eventName, forKey: .eventName)
            try container.encodeIfPresent(timeout, forKey: .timeout)
        case .condition(let rule):
            try rule.encode(to: encoder)
        case .contactUpdate(let firstName, let lastName, let unsubscribed):
            try container.encodeIfPresent(firstName, forKey: .firstName)
            try container.encodeIfPresent(lastName, forKey: .lastName)
            try container.encodeIfPresent(unsubscribed, forKey: .unsubscribed)
        case .contactDelete:
            break
        case .addToSegment(let segmentId):
            try container.encode(segmentId, forKey: .segmentId)
        }
    }
    
    public init(from decoder: Decoder, type: AutomationStepType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch type {
        case .trigger:
            let eventName = try container.decode(String.self, forKey: .eventName)
            self = .trigger(eventName: eventName)
        case .sendEmail:
            let template = try container.decode(AutomationSendEmailTemplate.self, forKey: .template)
            let subject = try container.decodeIfPresent(String.self, forKey: .subject)
            let from = try container.decodeIfPresent(String.self, forKey: .from)
            let replyTo = try container.decodeIfPresent(String.self, forKey: .replyTo)
            self = .sendEmail(template: template, subject: subject, from: from, replyTo: replyTo)
        case .delay:
            let duration = try container.decode(String.self, forKey: .duration)
            self = .delay(duration: duration)
        case .waitForEvent:
            let eventName = try container.decode(String.self, forKey: .eventName)
            let timeout = try container.decodeIfPresent(String.self, forKey: .timeout)
            self = .waitForEvent(eventName: eventName, timeout: timeout)
        case .condition:
            let rule = try AutomationConditionRule(from: decoder)
            self = .condition(rule)
        case .contactUpdate:
            let firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
            let lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
            let unsubscribed = try container.decodeIfPresent(Bool.self, forKey: .unsubscribed)
            self = .contactUpdate(firstName: firstName, lastName: lastName, unsubscribed: unsubscribed)
        case .contactDelete:
            self = .contactDelete
        case .addToSegment:
            let segmentId = try container.decode(String.self, forKey: .segmentId)
            self = .addToSegment(segmentId: segmentId)
        }
    }
    
    public init(from decoder: Decoder) throws {
        throw DecodingError.dataCorrupted(
            .init(codingPath: decoder.codingPath, debugDescription: "AutomationStepConfig must be decoded with a step type")
        )
    }
}

public struct AutomationStep: Codable {
    public var key: String
    public var type: AutomationStepType
    public var config: AutomationStepConfig
    
    public init(key: String, type: AutomationStepType, config: AutomationStepConfig) {
        self.key = key
        self.type = type
        self.config = config
    }
    
    public static func trigger(key: String, eventName: String) -> AutomationStep {
        AutomationStep(key: key, type: .trigger, config: .trigger(eventName: eventName))
    }
    
    public static func sendEmail(key: String,
                                 templateId: String,
                                 variables: [String: String]? = nil,
                                 subject: String? = nil,
                                 from: String? = nil,
                                 replyTo: String? = nil) -> AutomationStep {
        AutomationStep(
            key: key,
            type: .sendEmail,
            config: .sendEmail(
                template: AutomationSendEmailTemplate(id: templateId, variables: variables),
                subject: subject,
                from: from,
                replyTo: replyTo
            )
        )
    }
    
    public static func delay(key: String, duration: String) -> AutomationStep {
        AutomationStep(key: key, type: .delay, config: .delay(duration: duration))
    }
    
    public static func waitForEvent(key: String, eventName: String, timeout: String? = nil) -> AutomationStep {
        AutomationStep(key: key, type: .waitForEvent, config: .waitForEvent(eventName: eventName, timeout: timeout))
    }
    
    public static func condition(key: String, rule: AutomationConditionRule) -> AutomationStep {
        AutomationStep(key: key, type: .condition, config: .condition(rule))
    }
    
    public static func contactUpdate(key: String,
                                     firstName: String? = nil,
                                     lastName: String? = nil,
                                     unsubscribed: Bool? = nil) -> AutomationStep {
        AutomationStep(
            key: key,
            type: .contactUpdate,
            config: .contactUpdate(firstName: firstName, lastName: lastName, unsubscribed: unsubscribed)
        )
    }
    
    public static func contactDelete(key: String) -> AutomationStep {
        AutomationStep(key: key, type: .contactDelete, config: .contactDelete)
    }
    
    public static func addToSegment(key: String, segmentId: String) -> AutomationStep {
        AutomationStep(key: key, type: .addToSegment, config: .addToSegment(segmentId: segmentId))
    }
    
    enum CodingKeys: String, CodingKey {
        case key
        case type
        case config
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(type, forKey: .type)
        try container.encode(config, forKey: .config)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        type = try container.decode(AutomationStepType.self, forKey: .type)
        let configDecoder = try container.superDecoder(forKey: .config)
        config = try AutomationStepConfig(from: configDecoder, type: type)
    }
}

struct AutomationCreate: Encodable {
    var name: String
    var status: AutomationStatus?
    var steps: [AutomationStep]
    var connections: [AutomationConnection]
    
    init(name: String,
         status: AutomationStatus? = nil,
         steps: [AutomationStep],
         connections: [AutomationConnection]) {
        self.name = name
        self.status = status
        self.steps = steps
        self.connections = connections
    }
}

struct AutomationUpdate: Encodable {
    var name: String?
    var status: AutomationStatus?
    var steps: [AutomationStep]?
    var connections: [AutomationConnection]?
    
    init(name: String? = nil,
         status: AutomationStatus? = nil,
         steps: [AutomationStep]? = nil,
         connections: [AutomationConnection]? = nil) {
        self.name = name
        self.status = status
        self.steps = steps
        self.connections = connections
    }
}
