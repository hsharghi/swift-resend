import Foundation
import AsyncHTTPClient
import NIOHTTP1

extension ContactClient {
    
    public class Imports {
        
        private var client: ContactClient
        
        internal init(client: ContactClient) {
            self.client = client
        }
        
        /// Create a contact import from a CSV file. Processing is asynchronous — poll with `get(importId:)`.
        public func create(_ importRequest: ContactImportCreate) async throws -> ContactImportCreateResponse {
            var form = MultipartFormDataBuilder()
            form.appendFile(
                name: "file",
                filename: importRequest.filename,
                mimeType: "text/csv",
                data: importRequest.fileData
            )
            
            if let columnMap = importRequest.columnMap {
                let data = try client.encoder.encode(columnMap)
                guard let json = String(data: data, encoding: .utf8) else {
                    throw ResendError.validationError("Failed to encode column_map")
                }
                form.appendField(name: "column_map", value: json)
            }
            
            if let onConflict = importRequest.onConflict {
                form.appendField(name: "on_conflict", value: onConflict.rawValue)
            }
            
            if let segments = importRequest.segments {
                let data = try client.encoder.encode(segments)
                guard let json = String(data: data, encoding: .utf8) else {
                    throw ResendError.validationError("Failed to encode segments")
                }
                form.appendField(name: "segments", value: json)
            }
            
            if let topics = importRequest.topics {
                let data = try client.encoder.encode(topics)
                guard let json = String(data: data, encoding: .utf8) else {
                    throw ResendError.validationError("Failed to encode topics")
                }
                form.appendField(name: "topics", value: json)
            }
            
            let body = form.finalize()
            var headers = HTTPHeaders()
            headers.add(name: "Authorization", value: "Bearer \(client.apiKey)")
            headers.add(name: "Content-Type", value: form.contentType)
            
            let response = try await client.httpClient.execute(
                request: .init(
                    url: APIPath.getPath(for: .contactImportCreate),
                    method: .POST,
                    headers: headers,
                    body: .data(body)
                )
            ).get()
            
            return try client.parseResponse(response, to: ContactImportCreateResponse.self)
        }
        
        /// Retrieve a single contact import by ID.
        public func get(importId: String) async throws -> ContactImport {
            let response = try await client.httpClient.execute(
                request: .init(
                    url: APIPath.getPath(for: .contactImportGet(importId: importId)),
                    method: .GET,
                    headers: client.getAuthHeader()
                )
            ).get()
            
            return try client.parseResponse(response, to: ContactImport.self)
        }
        
        /// List contact imports, optionally filtered by status.
        public func list(
            status: ContactImportStatus? = nil,
            limit: Int = 10,
            after: String? = nil,
            before: String? = nil
        ) async throws -> ContactImportListResponse {
            var limitParam = limit
            limitParam = min(100, max(1, limitParam))
            
            var beforeParam = before
            if after != nil {
                beforeParam = nil
            }
            
            let response = try await client.httpClient.execute(
                request: .init(
                    url: APIPath.getPath(for: .contactImportList(
                        status: status?.rawValue,
                        limit: limitParam,
                        after: after,
                        before: beforeParam
                    )),
                    method: .GET,
                    headers: client.getAuthHeader()
                )
            ).get()
            
            return try client.parseResponse(response, to: ContactImportListResponse.self)
        }
    }
}
