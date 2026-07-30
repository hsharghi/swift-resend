import AsyncHTTPClient
import NIOHTTP1

public class TemplateClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Create a template.
    public func create(name: String,
                       html: String,
                       alias: String? = nil,
                       from: EmailAddress? = nil,
                       subject: String? = nil,
                       replyTo: [EmailAddress]? = nil,
                       text: String? = nil,
                       variables: [TemplateVariableInput]? = nil) async throws -> TemplateCreateResponse {
        
        let body = TemplateCreate(name: name,
                                  html: html,
                                  alias: alias,
                                  from: from,
                                  subject: subject,
                                  replyTo: replyTo,
                                  text: text,
                                  variables: variables)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .templateCreate),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: TemplateCreateResponse.self)
    }
    
    /// Retrieve a single template by ID or alias.
    public func get(idOrAlias: String) async throws -> Template {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .templateGet(idOrAlias: idOrAlias)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: Template.self)
    }
    
    /// Update an existing template by ID or alias.
    public func update(idOrAlias: String,
                       name: String? = nil,
                       html: String? = nil,
                       alias: String? = nil,
                       from: EmailAddress? = nil,
                       subject: String? = nil,
                       replyTo: [EmailAddress]? = nil,
                       text: String? = nil,
                       variables: [TemplateVariableInput]? = nil) async throws -> TemplateUpdateResponse {
        
        let body = TemplateUpdate(name: name,
                                  html: html,
                                  alias: alias,
                                  from: from,
                                  subject: subject,
                                  replyTo: replyTo,
                                  text: text,
                                  variables: variables)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .templateUpdate(idOrAlias: idOrAlias)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: TemplateUpdateResponse.self)
    }
    
    /// Delete a template by ID or alias.
    public func delete(idOrAlias: String) async throws -> TemplateDeleteResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .templateDelete(idOrAlias: idOrAlias)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: TemplateDeleteResponse.self)
    }
    
    /// Publish a template by ID or alias.
    public func publish(idOrAlias: String) async throws -> TemplatePublishResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .templatePublish(idOrAlias: idOrAlias)),
                method: .POST,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: TemplatePublishResponse.self)
    }
    
    /// Duplicate a template by ID or alias.
    public func duplicate(idOrAlias: String) async throws -> TemplateDuplicateResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .templateDuplicate(idOrAlias: idOrAlias)),
                method: .POST,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: TemplateDuplicateResponse.self)
    }
    
    /// Retrieve a list of templates.
    public func list(limit: Int = 20, after: String? = nil, before: String? = nil) async throws -> TemplateListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .templateList(limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: TemplateListResponse.self)
    }
}
