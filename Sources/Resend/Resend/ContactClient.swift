//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/2/24.
//

import AsyncHTTPClient
import NIOHTTP1

public class ContactClient: ResendClient {
      
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    // MARK: - Global Contacts
    
    /// Create a contact.
    public func create(email: String,
                       firstName: String? = nil,
                       lastName: String? = nil,
                       unsubscribed: Bool? = nil,
                       properties: [String: String]? = nil,
                       segments: [String]? = nil,
                       topics: [ContactTopicInput]? = nil) async throws -> String {
        
        let contact = ContactCreateGlobal(email: email,
                                          firstName: firstName,
                                          lastName: lastName,
                                          unsubscribed: unsubscribed,
                                          properties: properties,
                                          segments: segments,
                                          topics: topics)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactCreate),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(contact))
            )
        ).get()
        
        let createdContact = try parseResponse(response, to: ContactCreateResponse.self)
        return createdContact.id
    }
    
    /// Retrieve a single contact by ID or email.
    public func get(idOrEmail: String) async throws -> Contact {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactGetGlobal(idOrEmail: idOrEmail)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: Contact.self)
    }
    
    /// Update an existing contact by ID or email.
    public func update(idOrEmail: String,
                       email: String? = nil,
                       firstName: String? = nil,
                       lastName: String? = nil,
                       unsubscribed: Bool? = nil,
                       properties: [String: String]? = nil) async throws -> String {
        
        let contact = ContactUpdateGlobal(email: email,
                                          firstName: firstName,
                                          lastName: lastName,
                                          unsubscribed: unsubscribed,
                                          properties: properties)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactUpdateGlobal(idOrEmail: idOrEmail)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(contact))
            )
        ).get()
        
        let updatedContact = try parseResponse(response, to: ContactCreateResponse.self)
        return updatedContact.id
    }
    
    /// Remove an existing contact by ID or email.
    public func delete(idOrEmail: String) async throws -> ContactRemoveResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactDeleteGlobal(idOrEmail: idOrEmail)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ContactRemoveResponse.self)
    }
    
    /// Retrieve a list of contacts.
    public func list(segmentId: String? = nil,
                     limit: Int = 20,
                     after: String? = nil,
                     before: String? = nil) async throws -> ContactListGlobalResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactList(segmentId: segmentId, limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ContactListGlobalResponse.self)
    }
    
    /// Retrieve a list of segments for a contact.
    public func listSegments(contactId: String,
                             limit: Int = 20,
                             after: String? = nil,
                             before: String? = nil) async throws -> ContactSegmentListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactSegmentsList(contactId: contactId, limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ContactSegmentListResponse.self)
    }
    
    /// Add a contact to a segment.
    public func addToSegment(contactId: String, segmentId: String) async throws -> ContactSegmentResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactSegmentAdd(contactId: contactId, segmentId: segmentId)),
                method: .POST,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ContactSegmentResponse.self)
    }
    
    /// Remove a contact from a segment.
    public func removeFromSegment(contactId: String, segmentId: String) async throws -> ContactSegmentResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactSegmentRemove(contactId: contactId, segmentId: segmentId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ContactSegmentResponse.self)
    }
    
    /// Retrieve topics for a contact.
    public func listTopics(contactId: String,
                           limit: Int = 20,
                           after: String? = nil,
                           before: String? = nil) async throws -> ContactTopicListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactTopicsList(contactId: contactId, limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ContactTopicListResponse.self)
    }
    
    /// Update topics for a contact.
    public func updateTopics(contactId: String, topics: [ContactTopicInput]) async throws -> ContactTopicsUpdateResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactTopicsUpdate(contactId: contactId)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(topics))
            )
        ).get()
        
        return try parseResponse(response, to: ContactTopicsUpdateResponse.self)
    }
    
    // MARK: - Legacy Audience-scoped Contacts
    
    /// Create a contact inside an audience.
    @available(*, deprecated, message: "Use create(email:firstName:lastName:unsubscribed:...) with the global Contacts API. See Segments migration.")
    public func create(audienceId: String, 
                       email: String,
                       firstName: String? = nil,
                       lastName: String? = nil,
                       subscriptionStatus: Bool = true) async throws -> String {
        
        let contact = ContactCreate(email: email,
                                    firstName: firstName,
                                    lastName: lastName,
                                    subscriptionStatus: subscriptionStatus)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactAdd(audienceId: audienceId)),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(contact))
            )
        ).get()
        
        let createdContact = try parseResponse(response, to: ContactCreateResponse.self)
        return createdContact.id
    }
    
    /// Retrieve a single contact from an audience.
    @available(*, deprecated, message: "Use get(idOrEmail:) with the global Contacts API. See Segments migration.")
    public func get(audienceId: String,
                       contactId: String) async throws -> ResendContact {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactGet(contactId: contactId, audienceId: audienceId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ResendContact.self)
    }
    
    /// Update an existing contact.
    @available(*, deprecated, message: "Use update(idOrEmail:...) with the global Contacts API. See Segments migration.")
    public func update(audienceId: String,
                       contactId: String,
                       firstName: String? = nil,
                       lastName: String? = nil,
                       subscriptionStatus: Bool? = nil) async throws -> String {
        
        let contact = ContactUpdate(firstName: firstName,
                                    lastName: lastName,
                                    subscriptionStatus: subscriptionStatus)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactUpdate(contactId: contactId, audienceId: audienceId)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(contact))
            )
        ).get()
        
        let updatedContact = try parseResponse(response, to: ContactCreateResponse.self)
        return updatedContact.id
    }

    /// Remove an existing contact from an audience.
    @available(*, deprecated, message: "Use delete(idOrEmail:) with the global Contacts API. See Segments migration.")
    public func delete(audienceId: String,
                       contactId: String) async throws -> ContactDeleteResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactDelete(contactIdOrEmail: contactId, audienceId: audienceId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ContactDeleteResponse.self)
    }

    /// Remove an existing contact from an audience.
    @available(*, deprecated, message: "Use delete(idOrEmail:) with the global Contacts API. See Segments migration.")
    public func delete(audienceId: String,
                       email: String) async throws -> ContactDeleteResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactDelete(contactIdOrEmail: email, audienceId: audienceId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: ContactDeleteResponse.self)
    }

    
    /// Retrieve contacts from an audience.
    @available(*, deprecated, message: "Use list(segmentId:limit:after:before:) with the global Contacts API. See Segments migration.")
    public func list(audienceId: String) async throws -> [ResendContact] {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactListAudience(audienceId: audienceId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseContactListResponse(response)
    }
    
    public lazy var imports: Imports = {
        Imports(client: self)
    }()
    
}
