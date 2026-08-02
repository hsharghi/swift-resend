import AsyncHTTPClient
import NIOHTTP1

public class ContactPropertyClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Create a custom property for contacts.
    public func create(key: String,
                       type: ContactPropertyType,
                       fallbackValue: ContactPropertyValue? = nil) async throws -> ContactPropertyCreateResponse {
        
        let body = ContactPropertyCreate(key: key, type: type, fallbackValue: fallbackValue)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactPropertyCreate),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: ContactPropertyCreateResponse.self)
    }
    
    /// Retrieve a contact property by ID.
    public func get(propertyId: String) async throws -> ContactProperty {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactPropertyGet(propertyId: propertyId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ContactProperty.self)
    }
    
    /// Update a contact property fallback value.
    /// The `key` and `type` cannot be changed after creation.
    public func update(propertyId: String,
                       fallbackValue: ContactPropertyValue?) async throws -> ContactPropertyUpdateResponse {
        
        let body = ContactPropertyUpdate(fallbackValue: fallbackValue)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactPropertyUpdate(propertyId: propertyId)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: ContactPropertyUpdateResponse.self)
    }
    
    /// Delete a contact property.
    public func delete(propertyId: String) async throws -> ContactPropertyDeleteResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactPropertyDelete(propertyId: propertyId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ContactPropertyDeleteResponse.self)
    }
    
    /// Retrieve a list of contact properties.
    public func list(limit: Int = 20, after: String? = nil, before: String? = nil) async throws -> ContactPropertyListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactPropertyList(limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ContactPropertyListResponse.self)
    }
}
