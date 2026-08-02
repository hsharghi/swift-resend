import AsyncHTTPClient
import NIOHTTP1

public class WebhookClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Create a webhook.
    public func create(endpoint: String,
                       events: [WebhookEventType]) async throws -> WebhookCreateResponse {
        
        let body = WebhookCreate(endpoint: endpoint, events: events)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .webhookCreate),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: WebhookCreateResponse.self)
    }
    
    /// Retrieve a single webhook.
    public func get(webhookId: String) async throws -> Webhook {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .webhookGet(webhookId: webhookId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: Webhook.self)
    }
    
    /// Update an existing webhook.
    public func update(webhookId: String,
                       endpoint: String? = nil,
                       events: [WebhookEventType]? = nil,
                       status: WebhookStatus? = nil) async throws -> WebhookUpdateResponse {
        
        let body = WebhookUpdate(endpoint: endpoint, events: events, status: status)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .webhookUpdate(webhookId: webhookId)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: WebhookUpdateResponse.self)
    }
    
    /// Delete a webhook.
    public func delete(webhookId: String) async throws -> WebhookDeleteResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .webhookDelete(webhookId: webhookId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: WebhookDeleteResponse.self)
    }
    
    /// Retrieve a list of webhooks.
    public func list(limit: Int = 20, after: String? = nil, before: String? = nil) async throws -> WebhookListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .webhookList(limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: WebhookListResponse.self)
    }
}
