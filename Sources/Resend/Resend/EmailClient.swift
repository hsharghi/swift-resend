//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/2/24.
//

import AsyncHTTPClient
import NIOHTTP1

public class EmailClient: ResendClient {
        
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Send email
    public func send(email: ResendEmail) async throws -> String {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .emailSend),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(email))
            )
        ).get()
        
        let sentEmail = try parseResponse(response, to: EmailSentResponse.self)
        return sentEmail.id
        
    }

    /// Send batch emails
    /// Attachments and Tags are not supported in batch sending emails
    /// Id of successfully sent emails will be returned
    public func sendBatch(emails: [ResendBatchEmail]) async throws -> [String] {
                
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .emailBatchSend),
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
                url: APIPath.getPath(for: .emailGet(emailId: emailId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        return try parseResponse(response, to: EmailGetResponse.self)
        
    }
}
