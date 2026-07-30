import AsyncHTTPClient
import NIOHTTP1

public class SegmentClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Create a segment.
    public func create(name: String) async throws -> SegmentCreateResponse {
        
        let body = SegmentCreate(name: name)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .segmentCreate),
                method: .POST,
                headers: getAuthHeader(),
                body: .data(encoder.encode(body))
            )
        ).get()
        
        return try parseResponse(response, to: SegmentCreateResponse.self)
    }
    
    /// Retrieve a single segment.
    public func get(segmentId: String) async throws -> Segment {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .segmentGet(segmentId: segmentId)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: Segment.self)
    }
    
    /// Delete a segment.
    public func delete(segmentId: String) async throws -> SegmentDeleteResponse {
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .segmentDelete(segmentId: segmentId)),
                method: .DELETE,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: SegmentDeleteResponse.self)
    }
    
    /// Retrieve a list of segments.
    public func list(limit: Int = 20, after: String? = nil, before: String? = nil) async throws -> SegmentListResponse {
        var limitParam = limit
        limitParam = min(100, max(1, limitParam))
        
        var beforeParam = before
        if after != nil {
            beforeParam = nil
        }
        
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .segmentList(limit: limitParam, after: after, before: beforeParam)),
                method: .GET,
                headers: getAuthHeader()
            )
        ).get()
        
        return try parseResponse(response, to: SegmentListResponse.self)
    }
}
