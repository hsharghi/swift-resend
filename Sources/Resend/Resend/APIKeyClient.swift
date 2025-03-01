import AsyncHTTPClient
import NIOHTTP1

public class APIKeyClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Create a new API key
    public func create(name: String, permission: String, domainId: String? = nil) async throws -> APIKeyCreateResponse {
        let body = APIKeyCreate(name: name, permission: permission, domainId: domainId)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .apiKeyCreate),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: APIKeyCreateResponse.self)
    }
    
    /// List all API keys
    public func list() async throws -> [APIKey] {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .apiKeyList),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: APIKeyListResponse.self).data
    }
    
    /// Delete an API key
    public func delete(apiKeyId: String) async throws {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .apiKeyDelete(apiKeyId: apiKeyId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        guard response.status == .ok else {
            throw ResendError.unknownError
        }
    }
} 