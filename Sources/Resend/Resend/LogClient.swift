import AsyncHTTPClient
import NIOHTTP1

public class LogClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Retrieve a list of API request logs.
    public func list(limit: Int = 20, after: String? = nil, before: String? = nil) async throws -> LogListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .logList(limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: LogListResponse.self)
    }
    
    /// Retrieve a single API request log by ID.
    public func get(logId: String) async throws -> Log {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .logGet(logId: logId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: Log.self)
    }
}
