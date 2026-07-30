import AsyncHTTPClient
import NIOHTTP1

public class TopicClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Create a topic.
    public func create(name: String,
                       defaultSubscription: TopicSubscription,
                       description: String? = nil,
                       visibility: TopicVisibility? = nil) async throws -> TopicCreateResponse {
        
        let body = TopicCreate(name: name,
                               defaultSubscription: defaultSubscription,
                               description: description,
                               visibility: visibility)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .topicCreate),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: TopicCreateResponse.self)
    }
    
    /// Retrieve a single topic.
    public func get(topicId: String) async throws -> Topic {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .topicGet(topicId: topicId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: Topic.self)
    }
    
    /// Update an existing topic.
    public func update(topicId: String,
                       name: String? = nil,
                       description: String? = nil,
                       visibility: TopicVisibility? = nil) async throws -> TopicUpdateResponse {
        
        let body = TopicUpdate(name: name, description: description, visibility: visibility)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .topicUpdate(topicId: topicId)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: TopicUpdateResponse.self)
    }
    
    /// Delete a topic.
    public func delete(topicId: String) async throws -> TopicDeleteResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .topicDelete(topicId: topicId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: TopicDeleteResponse.self)
    }
    
    /// Retrieve a list of topics.
    public func list(limit: Int = 20, after: String? = nil, before: String? = nil) async throws -> TopicListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .topicList(limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: TopicListResponse.self)
    }
}
