import AsyncHTTPClient
import NIOHTTP1

public class BroadcastClient: ResendClient {
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }

    /// Create a new broadcast to send to your audience.
    public func create(broadcast: BroadcastCreate) async throws -> BroadcastCreateResponse {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .broadcastCreate),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(broadcast))
            )
        ).get()
        return try parseResponse(response, to: BroadcastCreateResponse.self)
    }

    /// List all broadcasts
    public func list() async throws -> [BroadcastSummary] {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .broadcastList),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        let listResponse = try parseResponse(response, to: BroadcastListResponse.self)
        return listResponse.data
    }

    /// Get a single broadcast by ID
    public func get(broadcastId: String) async throws -> BroadcastGetResponse {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .broadcastGet(broadcastId: broadcastId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        return try parseResponse(response, to: BroadcastGetResponse.self)
    }

    /// Update a broadcast
    public func update(update: BroadcastUpdate) async throws -> BroadcastCreateResponse {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .broadcastUpdate(broadcastId: update.id)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(update))
            )
        ).get()
        return try parseResponse(response, to: BroadcastCreateResponse.self)
    }

    /// Send a broadcast (optionally with schedule)
    public func send(broadcastId: String, scheduledAt: String? = nil) async throws -> BroadcastCreateResponse {
        var body: [String: String]? = nil
        if let scheduledAt = scheduledAt {
            body = ["scheduled_at": scheduledAt]
        }
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .broadcastSend(broadcastId: broadcastId)),
                method: .POST,
                headers: getAuthHeader(),
                body: body != nil ? .data(try encoder.encode(body)) : nil
            )
        ).get()
        return try parseResponse(response, to: BroadcastCreateResponse.self)
    }

    /// Delete a broadcast
    public func delete(broadcastId: String) async throws -> BroadcastCreateResponse {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .broadcastDelete(broadcastId: broadcastId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        return try parseResponse(response, to: BroadcastCreateResponse.self)
    }
} 