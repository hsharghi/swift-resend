import AsyncHTTPClient
import NIOHTTP1

extension DomainClient {
    
    public class Claims {
        
        private var client: DomainClient
        
        internal init(client: DomainClient) {
            self.client = client
        }
        
        /// Claim a domain that is already verified by another team.
        /// Resend creates a placeholder domain and returns a TXT record to prove ownership.
        public func create(name: String,
                           region: String? = nil,
                           customReturnPath: String? = nil,
                           openTracking: Bool? = nil,
                           clickTracking: Bool? = nil,
                           trackingSubdomain: String? = nil) async throws -> DomainClaim {
            
            let body = DomainClaimCreate(name: name,
                                         region: region,
                                         customReturnPath: customReturnPath,
                                         openTracking: openTracking,
                                         clickTracking: clickTracking,
                                         trackingSubdomain: trackingSubdomain)
            let response = try await client.httpClient.execute(
                request: .init(
                    url: APIPath.getPath(for: .domainClaimCreate),
                    method: .POST,
                    headers: client.getAuthHeader(),
                    body: .data(client.encoder.encode(body))
                )
            ).get()
            
            return try client.parseResponse(response, to: DomainClaim.self)
        }
        
        /// Retrieve the latest claim for a placeholder domain.
        public func get(domainId: String) async throws -> DomainClaim {
            let response = try await client.httpClient.execute(
                request: .init(
                    url: APIPath.getPath(for: .domainClaimGet(domainId: domainId)),
                    method: .GET,
                    headers: client.getAuthHeader()
                )
            ).get()
            
            return try client.parseResponse(response, to: DomainClaim.self)
        }
        
        /// Trigger DNS verification for a domain claim.
        /// Add the claim TXT record first, then poll `get(domainId:)` for status updates.
        public func verify(domainId: String) async throws -> DomainClaim {
            let response = try await client.httpClient.execute(
                request: .init(
                    url: APIPath.getPath(for: .domainClaimVerify(domainId: domainId)),
                    method: .POST,
                    headers: client.getAuthHeader()
                )
            ).get()
            
            return try client.parseResponse(response, to: DomainClaim.self)
        }
    }
}
