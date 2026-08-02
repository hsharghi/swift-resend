import AsyncHTTPClient
import NIOHTTP1

public class SuppressionClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Add an email address to the suppression list.
    public func add(email: String) async throws -> SuppressionAddResponse {
        
        let body = SuppressionAdd(email: email)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .suppressionAdd),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: SuppressionAddResponse.self)
    }
    
    /// Add an email address to the suppression list.
    public func add(email: EmailAddress) async throws -> SuppressionAddResponse {
        try await add(email: email.email)
    }
    
    /// Retrieve a single suppression by ID or email.
    public func get(idOrEmail: String) async throws -> Suppression {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .suppressionGet(idOrEmail: idOrEmail)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: Suppression.self)
    }
    
    /// Remove a single suppression by ID or email.
    public func remove(idOrEmail: String) async throws -> SuppressionRemoveResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .suppressionRemove(idOrEmail: idOrEmail)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: SuppressionRemoveResponse.self)
    }
    
    /// Retrieve a list of suppressions.
    public func list(origin: SuppressionOrigin? = nil,
                     limit: Int = 20,
                     after: String? = nil,
                     before: String? = nil) async throws -> SuppressionListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .suppressionList(origin: origin?.rawValue,
                                                           limit: limitParam,
                                                           after: after,
                                                           before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: SuppressionListResponse.self)
    }
    
    /// Add up to 100 email addresses to the suppression list at once.
    public func batchAdd(emails: [String]) async throws -> SuppressionBatchAddResponse {
        guard !emails.isEmpty, emails.count <= 100 else {
            throw ResendError.validationError("Batch add requires between 1 and 100 email addresses.")
        }
        
        let body = SuppressionBatchAdd(emails: emails)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .suppressionBatchAdd),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: SuppressionBatchAddResponse.self)
    }
    
    /// Add up to 100 email addresses to the suppression list at once.
    public func batchAdd(emails: [EmailAddress]) async throws -> SuppressionBatchAddResponse {
        try await batchAdd(emails: emails.map(\.email))
    }
    
    /// Remove up to 100 suppressions by email address.
    public func batchRemove(emails: [String]) async throws -> SuppressionBatchRemoveResponse {
        guard !emails.isEmpty, emails.count <= 100 else {
            throw ResendError.validationError("Batch remove requires between 1 and 100 email addresses.")
        }
        
        let body = SuppressionBatchRemove(emails: emails)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .suppressionBatchRemove),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: SuppressionBatchRemoveResponse.self)
    }
    
    /// Remove up to 100 suppressions by ID.
    public func batchRemove(ids: [String]) async throws -> SuppressionBatchRemoveResponse {
        guard !ids.isEmpty, ids.count <= 100 else {
            throw ResendError.validationError("Batch remove requires between 1 and 100 suppression IDs.")
        }
        
        let body = SuppressionBatchRemove(ids: ids)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .suppressionBatchRemove),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: SuppressionBatchRemoveResponse.self)
    }
}
