//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/2/24.
//

import AsyncHTTPClient
import NIOHTTP1

public class AudienceClient: ResendClient {
    
    let path = "audiences"
    
    /// Create a list of contacts (Audience).
    public func create(name: String) async throws -> AudienceCreateResponse {
        
        let body = AudienceCreate(name: name)
        let response = try await httpClient.execute(
            request: .init(
                url: apiURL + "/\(path)",
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: AudienceCreateResponse.self)

    }
    
    
    /// Get an audience
    public func get(audienceId: String) async throws -> Audience {
        
        let response = try await httpClient.execute(
            request: .init(
                url: apiURL + "/\(path)/\(audienceId)",
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: Audience.self)

    }

    
    /// Delete an audience
    public func delete(audienceId: String) async throws -> AudienceDeleteResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: apiURL + "/\(path)/\(audienceId)",
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: AudienceDeleteResponse.self)

    }
    
    
    /// Retrieve a list of audiences.
    public func list() async throws -> [Audience] {
        
        let response = try await httpClient.execute(
            request: .init(
                url: apiURL + "/\(path)",
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseContactListResponse(response)

    }
}
