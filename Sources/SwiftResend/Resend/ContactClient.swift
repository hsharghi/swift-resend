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
    
    /// Create a contact inside an audience.
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

    
    /// Retrieve a single contact from an audience.
    public func list(audienceId: String) async throws -> [ResendContact] {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .contactList(audienceId: audienceId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseContactListResponse(response)
    }
    
}
