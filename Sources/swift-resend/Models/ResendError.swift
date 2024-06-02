import Foundation

public struct ErrorResponse: Codable {
    
    public var name: String?
    public var statusCode: Int
    public var message: String
    
}

public enum ResendError: String, Error, Codable {

    case missingRequiredField = "missing_required_field"
    case invalidAttachment = "invalid_attachment"
    case missingApiKey = "missing_api_key"
    case invalidApiKey = "invalid_api_key"
    case invalidFromAddress = "invalid_from_address"
    case invalidToAddress = "invalid_to_address"
    case notFound = "not_found"
    case methodNotAllowed = "method_not_allowed"
    case invalidScope = "invalid_scope"
    case rateLimitExceeded = "rate_limit_exceeded"
    case dailyQuotaExceeded = "daily_quota_exceeded"
    case internalServerError = "internal_server_error"
    case unknownError
    
    
    
    
}
