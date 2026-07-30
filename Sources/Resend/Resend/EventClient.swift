import AsyncHTTPClient
import NIOHTTP1

public class EventClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Create an event definition.
    public func create(name: String,
                       schema: [String: EventSchemaFieldType]? = nil) async throws -> EventCreateResponse {
        
        let body = EventCreate(name: name, schema: schema)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .eventCreate),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: EventCreateResponse.self)
    }
    
    /// Retrieve a single event by ID or name.
    public func get(identifier: String) async throws -> Event {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .eventGet(identifier: identifier)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: Event.self)
    }
    
    /// Update an event schema by ID or name.
    public func update(identifier: String,
                       schema: [String: EventSchemaFieldType]?) async throws -> EventUpdateResponse {
        
        let body = EventUpdate(schema: schema)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .eventUpdate(identifier: identifier)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: EventUpdateResponse.self)
    }
    
    /// Delete an event by ID or name.
    public func delete(identifier: String) async throws -> EventDeleteResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .eventDelete(identifier: identifier)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: EventDeleteResponse.self)
    }
    
    /// Retrieve a list of events.
    public func list(limit: Int = 20, after: String? = nil, before: String? = nil) async throws -> EventListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .eventList(limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: EventListResponse.self)
    }
    
    /// Send an event to trigger automations.
    /// Exactly one of `contactId` or `email` must be provided.
    public func send(event: String,
                     contactId: String? = nil,
                     email: String? = nil,
                     payload: [String: String]? = nil) async throws -> EventSendResponse {
        
        switch (contactId != nil, email != nil) {
        case (true, false), (false, true):
            break
        default:
            throw ResendError.validationError("Exactly one of contactId or email must be provided.")
        }
        
        let body = EventSend(event: event, contactId: contactId, email: email, payload: payload)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .eventSend),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: EventSendResponse.self)
    }
}
