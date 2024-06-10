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
    
    /// Retrieve a list of audiences.
    public func list() async throws -> [Audience] {
        
        let response = try await httpClient.execute(
            request: .init(
                url: apiURL + "/\(path)",
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: [Audience].self)

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

    /// Send batch emails
    /// Attachments and Tags are not supported in batch sending emails
    /// Id of successfully sent emails will be returned
    public func sendBatch(emails: [ResendBatchEmail]) async throws -> [EmailSentResponse] {
                
        let response = try await httpClient.execute(
            request: .init(
                url: apiURL + "/\(path)/batch",
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(emails))
            )
        ).get()
        
        return try parseBatchSentResponse(response)

    }
    
    /// Get email info
    /// Attachments will not be in the response. (Not supported by the API)
    /// Tags will not be in the response.
    public func get(emailId: String) async throws -> EmailGetResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: apiURL + "/\(path)/\(emailId)",
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        return try parseGetResponse(response)
        
    }
}
