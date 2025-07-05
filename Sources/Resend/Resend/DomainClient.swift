import AsyncHTTPClient
import NIOHTTP1

public class DomainClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Create a new domain
    public func create(name: String, region: String = "us-east-1") async throws -> DomainCreateResponse {
        let body = DomainCreate(name: name, region: region)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .domainCreate),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: DomainCreateResponse.self)
    }
    
    /// Retrieve a domain
    public func retrieve(domainId: String) async throws -> Domain {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .domainRetrieve(domainId: domainId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: Domain.self)
    }
    
    /// Verify a domain
    public func verify(domainId: String) async throws -> DomainVerifyResponse {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .domainVerify(domainId: domainId)),
                method: .POST,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: DomainVerifyResponse.self)
    }
    
    /// Update a domain
    /// - Parameters:
    ///   - domainId: The ID of the domain to update
    ///   - clickTracking: Track clicks within the body of each HTML email
    ///   - openTracking: Track the open rate of each email
    ///   - tls: TLS policy (.opportunistic or .enforced)
    /// - Returns: The updated Domain object
    public func update(domainId: String, clickTracking: Bool, openTracking: Bool, tls: DomainTLSMode = .opportunistic) async throws -> Domain {
        let body = DomainUpdate(clickTracking: clickTracking, openTracking: openTracking, tls: tls)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .domainUpdate(domainId: domainId)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: Domain.self)
    }
    
    /// List all domains
    public func list() async throws -> [Domain] {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .domainList),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: DomainListResponse.self).data
    }
    
    /// Delete a domain
    /// - Parameter domainId: The ID of the domain to delete
    /// - Returns: DomainDeleteResponse containing the result of the deletion
    public func delete(domainId: String) async throws -> DomainDeleteResponse {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .domainDelete(domainId: domainId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: DomainDeleteResponse.self)
    }
} 