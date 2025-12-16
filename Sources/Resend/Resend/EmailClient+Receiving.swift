//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/2/24.
//

import AsyncHTTPClient
import NIOHTTP1

extension EmailClient {
    public class Receiving {
        
        private var client: EmailClient
        
        internal init(client: EmailClient) {
            self.client = client
        }
        
        public lazy var attachments = {
            Receiving.Attachments(client: self.client)
        }()
        
        /// Retrieve a list of received emails for the authenticated user.
        /// You can list all emails received by your team.
        /// The list returns references to individual emails.
        /// The `limit` parameter is optional. If you do not provide a limit, all attachments will be returned in a single response.
        /// `before` and `after` parameters can not be used together
        public func list(limit: Int = 20, after: String? = nil, before: String? = nil) async throws -> ReceivedEmailListResponse {
            var limitParam = limit
            limitParam = min(100, max(1, limitParam))
            
            // `before` parameter can not be used with `after` parameter.
            var beforeParam = before
            if after != nil {
                beforeParam = nil
            }
            let response = try await client.httpClient.execute(
                request: .init(
                    url: APIPath.getPath(for: .emailReceivingList(limit: limitParam, after: after, before: beforeParam)),
                    method: .GET,
                    headers: client.getAuthHeader()
                )
            ).get()
            return try client.parseResponse(response, to: ReceivedEmailListResponse.self)
        }

        /// Retrieve a single email from a sent email.
        public func get(emailId: String) async throws -> ReceivedEmailResponse {
            let response = try await client.httpClient.execute(
                request: .init(
                    url: APIPath.getPath(for: .emailReceivingGet(emailId: emailId)),
                    method: .GET,
                    headers: client.getAuthHeader()
                )
            ).get()
            return try client.parseResponse(response, to: ReceivedEmailResponse.self)
        }
    }
}


extension EmailClient.Receiving {
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
                    url: APIPath.getPath(for: .emailReceivingAttachmentList(emailId: emailId, limit: limitParam, after: after, before: beforeParam)),
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
                    url: APIPath.getPath(for: .emailReceivingAttachmentGet(attachmentId: attachmentId, emailId: emailId)),
                    method: .GET,
                    headers: client.getAuthHeader()
                )
            ).get()
            return try client.parseResponse(response, to: EmailAttachmentItem.self)

        }
    }
}
