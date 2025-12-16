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
    
    /// Retrieve a list of emails sent by your team.
    /// The list returns references to individual emails.
    /// If needed, you can use the id of an email to retrieve the email HTML to plain text using the Retrieve Email endpoint
    /// Or the Retrieve Attachments endpoint to get an email’s attachments.
    /// The `limit` parameter is optional. If you do not provide a limit, all attachments will be returned in a single response.
    /// `before` and `after` parameters can not be used together
    public func list(limit: Int = 20, after: String? = nil, before: String? = nil) async throws -> EmailListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        // `before` parameter can not be used with `after` parameter.
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .emailList(limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        return try parseResponse(response, to: EmailListResponse.self)

    }
    
    /// Update schedule date
    /// scheduledAt parameter can be in natural language (e.g.: in 1 min) or `Date` object
    /// Id of the email will be returned on successful update
    public func update(emailId: String, scheduledAt: EmailSchedule) async throws -> String {
        let updateRequest = ResendEmailUpdate(id: emailId, scheduledAt: scheduledAt)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .emailGet(emailId: emailId)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(updateRequest))
            )
        ).get()
        let updateResponse = try parseResponse(response, to: EmailSentResponse.self)
        return updateResponse.id

    }

    /// Cancel a scheduled email
    /// Id of the email will be returned on successful cancelation
    public func cancel(emailId: String) async throws -> String {
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .cancleSchedule(emailId: emailId)),
                method: .POST,
                headers: getAuthHeader(),
            )
        ).get()
        let canceledEmail = try parseResponse(response, to: EmailSentResponse.self)
        return canceledEmail.id
    }
    
    public lazy var attachments: Attachments = {
        Attachments(client: self)
    }()
}

extension EmailClient {
    public class Attachments {
        
        private var client: EmailClient
        
        internal init(client: EmailClient) {
            self.client = client
        }
        
        /// Retrieve a list of attachments from a sent email.
        /// The `limit` parameter is optional. If you do not provide a limit, all attachments will be returned in a single response.
        /// `before` and `after` parameters can not be used together
        public func list(emailId: String, limit: Int = 20, after: String? = nil, before: String? = nil) async throws -> EmailAttachmentResponse {
            var limitParam = limit
            limitParam = min(100, max(1, limitParam))
            
            // `before` parameter can not be used with `after` parameter.
            var beforeParam = before
            if after != nil {
                beforeParam = nil
            }
            let response = try await client.httpClient.execute(
                request: .init(
                    url: APIPath.getPath(for: .attachmentList(emailId: emailId, limit: limitParam, after: after, before: beforeParam)),
                    method: .GET,
                    headers: client.getAuthHeader()
                )
            ).get()
            return try client.parseResponse(response, to: EmailAttachmentResponse.self)

        }

        /// Retrieve a single attachment from a sent email.
        public func get(attachmentId: String, emailId: String) async throws -> EmailAttachmentItem {
            let response = try await client.httpClient.execute(
                request: .init(
                    url: APIPath.getPath(for: .attachmentGet(attachmentId: attachmentId, emailId: emailId)),
                    method: .GET,
                    headers: client.getAuthHeader()
                )
            ).get()
            return try client.parseResponse(response, to: EmailAttachmentItem.self)

        }
    }
}
