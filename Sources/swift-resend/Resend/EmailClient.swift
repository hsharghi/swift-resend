//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/2/24.
//

import AsyncHTTPClient
import NIOHTTP1

public class EmailClient: ResendClient {
    
    let path = "emails"
    
    /// Send email
    public func send(email: ResendEmail) async throws -> EmailSentResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: apiURL + "/\(path)",
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(email))
            )
        ).get()
        
        return try parseSentResponse(response)
        
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
