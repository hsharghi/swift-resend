import AsyncHTTPClient
import NIOHTTP1

public class OAuthGrantClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Retrieve a list of OAuth grants for the authenticated team.
    public func list(limit: Int = 20, after: String? = nil, before: String? = nil) async throws -> OAuthGrantListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .oauthGrantList(limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: OAuthGrantListResponse.self)
    }
    
    /// Revoke an OAuth grant. Invalidates every access and refresh token issued under it.
    public func revoke(grantId: String) async throws -> OAuthGrantRevokeResponse {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .oauthGrantRevoke(grantId: grantId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: OAuthGrantRevokeResponse.self)
    }
}
