import Foundation

public enum EventSchemaFieldType: String, Codable {
    case string
    case number
    case boolean
    case date
}

struct EventCreate: Encodable {
    var name: String
    var schema: [String: EventSchemaFieldType]?
    
    init(name: String, schema: [String: EventSchemaFieldType]? = nil) {
        self.name = name
        self.schema = schema
    }
}

struct EventUpdate: Encodable {
    var schema: [String: EventSchemaFieldType]?
    
    init(schema: [String: EventSchemaFieldType]?) {
        self.schema = schema
    }
}

struct EventSend: Encodable {
    var event: String
    var contactId: String?
    var email: String?
    var payload: [String: String]?
    
    init(event: String,
         contactId: String? = nil,
         email: String? = nil,
         payload: [String: String]? = nil) {
        self.event = event
        self.contactId = contactId
        self.email = email
        self.payload = payload
    }
    
    enum CodingKeys: String, CodingKey {
        case event
        case contactId = "contact_id"
        case email
        case payload
    }
}
