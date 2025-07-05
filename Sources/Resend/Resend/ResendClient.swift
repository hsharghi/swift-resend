//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 6/2/24.
//

import Foundation
import NIO
import AsyncHTTPClient
import NIOHTTP1
import NIOFoundationCompat

public class ResendClient {
    
    let httpClient: HTTPClient
    let apiKey: String
    
    public init(httpClient: HTTPClient, apiKey: String) {
        self.httpClient = httpClient
        self.apiKey = apiKey
    }
    
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
         encoder.dateEncodingStrategy = .secondsSince1970
         return encoder
    }()
    
    let decoder: JSONDecoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()

    func getAuthHeader() -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer \(apiKey)")
        headers.add(name: "Content-Type", value: "application/json")
        return headers
    }
    
    public var emails: EmailClient {
        EmailClient(httpClient: httpClient, apiKey: apiKey)
    }    
    
    public var audiences: AudienceClient {
        AudienceClient(httpClient: httpClient, apiKey: apiKey)
    }
    
    public var contacts: ContactClient {
        ContactClient(httpClient: httpClient, apiKey: apiKey)
    }    
    
    public var apiKeys: APIKeyClient {
        APIKeyClient(httpClient: httpClient, apiKey: apiKey)
    }
  
    public var domains: DomainClient {
        DomainClient(httpClient: httpClient, apiKey: apiKey)
    }
    
    func parseResponse<T: Decodable>(_ response: HTTPClient.Response, to: T.Type) throws -> T {
        let byteBuffer: ByteBuffer = response.body ?? .init()
        
        if response.status == .ok || response.status == .created {
            return try decodeResponse(T.self, from: byteBuffer)
        } else {
            let errorResponse = try decodeResponse(ErrorResponse.self, from: byteBuffer)
            try parseErrorResponse(errorResponse)
        }
    }
    
    
    func decodeResponse<T: Decodable>(_ type: T.Type, from byteBuffer: ByteBuffer) throws -> T {
        do {
            return try decoder.decode(T.self, from: byteBuffer)
        } catch {
            throw ResendError.decodingError("Failed to decode\n \(String(buffer: byteBuffer)) to \(String(describing: T.Type.self))")
        }
    }
    
    func parseErrorResponse(_ errorResponse: ErrorResponse) throws -> Never {
        switch errorResponse.name {
        case "missing_required_field":
            throw ResendError.missingRequiredField(errorResponse.message)
        case "missing_api_key":
            throw ResendError.missingApiKey(errorResponse.message)
        case "invalid_attachment":
            throw ResendError.invalidAttachment(errorResponse.message)
        case "invalid_api_key":
            throw ResendError.invalidApiKey(errorResponse.message)
        case "invalid_from_address":
            throw ResendError.invalidFromAddress(errorResponse.message)
        case "invalid_to_address":
            throw ResendError.invalidToAddress(errorResponse.message)
        case "not_found":
            throw ResendError.notFound(errorResponse.message)
        case "method_not_allowed":
            throw ResendError.methodNotAllowed(errorResponse.message)
        case "invalid_scope":
            throw ResendError.invalidScope(errorResponse.message)
        case "rate_limit_exceeded":
            throw ResendError.rateLimitExceeded(errorResponse.message)
        case "daily_quota_exceeded":
            throw ResendError.dailyQuotaExceeded(errorResponse.message)
        case "internal_server_error":
            throw ResendError.internalServerError(errorResponse.message)
        case "validation_error":
            throw ResendError.validationError(errorResponse.message)
        case "restricted_api_key":
            throw ResendError.restrictedApiKey(errorResponse.message)
        case "invalid_idempotency_key":
            throw ResendError.invalidIdempotencyKey(errorResponse.message)
        case "invalid_idempotent_request":
            throw ResendError.invalidIdempotentRequest(errorResponse.message)
        case "concurrent_idempotent_requests":
            throw ResendError.concurrentIdempotentRequests(errorResponse.message)
        default:
            throw ResendError.unknownError
        }
    }
    
    
}
