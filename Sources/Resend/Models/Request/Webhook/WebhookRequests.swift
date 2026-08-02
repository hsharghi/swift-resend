import Foundation

public enum WebhookStatus: String, Codable {
    case enabled
    case disabled
}

public enum WebhookEventType: String, Codable {
    case emailBounced = "email.bounced"
    case emailClicked = "email.clicked"
    case emailComplained = "email.complained"
    case emailDelivered = "email.delivered"
    case emailDeliveryDelayed = "email.delivery_delayed"
    case emailFailed = "email.failed"
    case emailOpened = "email.opened"
    case emailReceived = "email.received"
    case emailScheduled = "email.scheduled"
    case emailSent = "email.sent"
    case emailSuppressed = "email.suppressed"
    case domainCreated = "domain.created"
    case domainUpdated = "domain.updated"
    case domainDeleted = "domain.deleted"
    case contactCreated = "contact.created"
    case contactUpdated = "contact.updated"
    case contactDeleted = "contact.deleted"
    case suppressionAdded = "suppression.added"
    case suppressionRemoved = "suppression.removed"
}

struct WebhookCreate: Encodable {
    
    var endpoint: String
    var events: [WebhookEventType]
    
    init(endpoint: String, events: [WebhookEventType]) {
        self.endpoint = endpoint
        self.events = events
    }
}

struct WebhookUpdate: Encodable {
    
    var endpoint: String?
    var events: [WebhookEventType]?
    var status: WebhookStatus?
    
    init(endpoint: String? = nil,
         events: [WebhookEventType]? = nil,
         status: WebhookStatus? = nil) {
        self.endpoint = endpoint
        self.events = events
        self.status = status
    }
}
