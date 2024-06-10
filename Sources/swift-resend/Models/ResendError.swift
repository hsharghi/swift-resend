import Foundation


public struct ErrorResponse: Codable {
    
    public var name: String?
    public var statusCode: Int
    public var message: String
    
}

//public enum ResendError: String, Error, Codable {
//
//    case missingRequiredField = "missing_required_field"
//    case invalidAttachment = "invalid_attachment"
//    case missingApiKey = "missing_api_key"
//    case invalidApiKey = "invalid_api_key"
//    case invalidFromAddress = "invalid_from_address"
//    case invalidToAddress = "invalid_to_address"
//    case notFound = "not_found"
//    case methodNotAllowed = "method_not_allowed"
//    case invalidScope = "invalid_scope"
//    case rateLimitExceeded = "rate_limit_exceeded"
//    case dailyQuotaExceeded = "daily_quota_exceeded"
//    case internalServerError = "internal_server_error"
//    case unknownError
//
//
//
//
//}

public enum ResendError: Error {
        
    
    case missingRequiredField(String)
    case invalidAttachment(String)
    case missingApiKey(String)
    case invalidApiKey(String)
    case restrictedApiKey(String)
    case invalidFromAddress(String)
    case invalidToAddress(String)
    case notFound(String)
    case methodNotAllowed(String)
    case invalidScope(String)
    case rateLimitExceeded(String)
    case dailyQuotaExceeded(String)
    case validationError(String)
    case internalServerError(String)
    case decodingError(String)
    case unknownError
    
    
    /// Identifier
    public var identifier: String {
        switch self {
        case .missingRequiredField:
            return "missing_required_field"
        case .invalidAttachment:
            return "invalid_attachment"
        case .missingApiKey:
            return "missing_api_key"
        case .invalidApiKey:
            return "invalid_api_key"
        case .restrictedApiKey:
            return "restricted_api_key"
        case .invalidFromAddress:
            return "invalid_from_address"
        case .invalidToAddress:
            return "invalid_to_address"
        case .notFound:
            return "not_found"
        case .methodNotAllowed:
            return "method_not_allowed"
        case .invalidScope:
            return "invalid_scope"
        case .rateLimitExceeded:
            return "rate_limit_exceeded"
        case .dailyQuotaExceeded:
            return "daily_quota_exceeded"
        case .validationError:
            return "validation_error"
        case .internalServerError:
            return "internal_server_error"
        case .decodingError:
            return "decoding_error"
        case .unknownError:
            return "unknown_error"
        }
    }
    
    /// Reason
    public var message: String {
        switch self {
        case .missingRequiredField(let message),
                .invalidAttachment(let message),
                .missingApiKey(let message),
                .invalidApiKey(let message),
                .restrictedApiKey(let message),
                .invalidFromAddress(let message),
                .invalidToAddress(let message),
                .notFound(let message),
                .methodNotAllowed(let message),
                .invalidScope(let message),
                .rateLimitExceeded(let message),
                .dailyQuotaExceeded(let message),
                .validationError(let message),
                .decodingError(let message),
                .internalServerError(let message):
            return message
        case .unknownError:
            return "Unknown error"
        }
    }
    
    
    public var suggestion: String {
        switch self {
        case .missingRequiredField:
            return "Check the error message to see the list of missing fields."
        case .invalidAttachment:
            return "Attachments must either have a content (strings, Buffer, or Stream contents) or path to a remote resource (better for larger attachments)."
        case .missingApiKey:
            return "Include the following header Authorization: Bearer YOUR_API_KEY in the request."
        case .restrictedApiKey:
            return "This API key is restricted to only send emails."
        case .invalidApiKey:
            return "Generate a new API key in the dashboard."
        case .invalidFromAddress:
            return "Review your existing domains in the dashboard."
        case .invalidToAddress:
            return "In order to send emails to any external address, you need to add a domain and use that as the from address instead of onboarding@resend.dev."
        case .notFound:
            return "Change your request URL to match a valid API endpoint."
        case .methodNotAllowed:
            return "Change the HTTP method to follow the documentation for the endpoint."
        case .invalidScope:
            return "Change the scope to follow the documentation for the endpoint."
        case .rateLimitExceeded:
            return "You should read the response headers and reduce the rate at which you request the API. This can be done by introducing a queue mechanism or reducing the number of concurrent requests per second. If you have specific requirements, contact support to request a rate increase."
        case .dailyQuotaExceeded:
            return "Upgrade your plan to remove daily quota limit or wait until 24 hours have passed to continue sending."
        case .validationError:
            return ""
        case .internalServerError:
            return "Try the request again later. If the error does not resolve, check our status page for service updates."
        case .decodingError:
            return ""
        case .unknownError:
            return ""
        }
        
    }
}
