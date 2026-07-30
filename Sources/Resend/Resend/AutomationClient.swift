import AsyncHTTPClient
import NIOHTTP1

public class AutomationClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Create an automation.
    public func create(name: String,
                       status: AutomationStatus? = nil,
                       steps: [AutomationStep],
                       connections: [AutomationConnection]) async throws -> AutomationCreateResponse {
        
        let body = AutomationCreate(name: name, status: status, steps: steps, connections: connections)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .automationCreate),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: AutomationCreateResponse.self)
    }
    
    /// Retrieve a single automation.
    public func get(automationId: String) async throws -> Automation {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .automationGet(automationId: automationId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: Automation.self)
    }
    
    /// Update an automation.
    public func update(automationId: String,
                       name: String? = nil,
                       status: AutomationStatus? = nil,
                       steps: [AutomationStep]? = nil,
                       connections: [AutomationConnection]? = nil) async throws -> AutomationUpdateResponse {
        
        let body = AutomationUpdate(name: name, status: status, steps: steps, connections: connections)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .automationUpdate(automationId: automationId)),
                method: .PATCH,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: AutomationUpdateResponse.self)
    }
    
    /// Delete an automation.
    public func delete(automationId: String) async throws -> AutomationDeleteResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .automationDelete(automationId: automationId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: AutomationDeleteResponse.self)
    }
    
    /// Stop an automation.
    public func stop(automationId: String) async throws -> AutomationStopResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .automationStop(automationId: automationId)),
                method: .POST,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: AutomationStopResponse.self)
    }
    
    /// Retrieve a list of automations.
    public func list(status: AutomationStatus? = nil,
                     limit: Int = 20,
                     after: String? = nil,
                     before: String? = nil) async throws -> AutomationListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .automationList(status: status?.rawValue, limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: AutomationListResponse.self)
    }
    
    /// Retrieve a list of automation runs.
    public func listRuns(automationId: String,
                         status: String? = nil,
                         limit: Int = 20,
                         after: String? = nil,
                         before: String? = nil) async throws -> AutomationRunListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .automationRunsList(automationId: automationId, status: status, limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: AutomationRunListResponse.self)
    }
    
    /// Retrieve a single automation run.
    public func getRun(automationId: String, runId: String) async throws -> AutomationRun {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .automationRunGet(automationId: automationId, runId: runId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: AutomationRun.self)
    }
}
