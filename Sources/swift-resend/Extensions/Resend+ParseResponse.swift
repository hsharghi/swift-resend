//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/9/24.
//

import NIO
import AsyncHTTPClient
import NIOFoundationCompat

extension EmailClient {
    func parseSentResponse(_ response: HTTPClient.Response) throws -> EmailSentResponse {
        let byteBuffer: ByteBuffer = response.body ?? .init()
        switch response.status {
        case .ok:
            let res = try decoder.decode(EmailSentResponse.self, from: byteBuffer)
            return .init(id: res.id)
        default:
            let errorResponse = try decoder.decode(ErrorResponse.self, from: byteBuffer)
            switch errorResponse.name {
            case "missing_required_field":
                throw ResendError.missingApiKey(errorResponse.message)
            case "invalid_attachment":
                throw ResendError.invalidAttachment(errorResponse.message)
            case "missing_api_key":
                throw ResendError.missingApiKey(errorResponse.message)
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
            default:
                throw ResendError.unknownError
            }
        }
    }
    
    func parseBatchSentResponse(_ response: HTTPClient.Response) throws -> [EmailSentResponse] {
        let byteBuffer: ByteBuffer = response.body ?? .init()
        switch response.status {
        case .ok:
            let res = try decoder.decode(EmailSentBatchResponse.self, from: byteBuffer)
            return res.data.map { EmailSentResponse(id: $0.id)}
        default:
            let errorResponse = try decoder.decode(ErrorResponse.self, from: byteBuffer)
            switch errorResponse.name {
            case "missing_required_field":
                throw ResendError.missingApiKey(errorResponse.message)
            case "invalid_attachment":
                throw ResendError.invalidAttachment(errorResponse.message)
            case "missing_api_key":
                throw ResendError.missingApiKey(errorResponse.message)
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
            default:
                throw ResendError.unknownError
            }
        }
    }
    
    func parseGetResponse(_ response: HTTPClient.Response) throws -> EmailGetResponse {
        let byteBuffer: ByteBuffer = response.body ?? .init()
        switch response.status {
        case .ok:
            let res = try decoder.decode(EmailGetResponse.self, from: byteBuffer)
            return res
        default:
            let errorResponse = try decoder.decode(ErrorResponse.self, from: byteBuffer)
            switch errorResponse.name {
            case "restricted_api_key":
                throw ResendError.restrictedApiKey(errorResponse.message)
            default:
                throw ResendError.unknownError
            }
        }
    }
    
}
