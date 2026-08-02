import Foundation

/// How the OAuth client authenticates at the token endpoint.
public enum OAuthTokenEndpointAuthMethod {
    /// Public client (`token_endpoint_auth_method: none`). PKCE only; no client secret.
    case none
    /// Confidential client: send `client_secret` in the request body.
    case clientSecretPost
    /// Confidential client: send `client_id` and `client_secret` via HTTP Basic auth.
    case clientSecretBasic
}

/// Exchange an authorization code (with PKCE) for tokens.
public struct OAuthAuthorizationCodeTokenRequest {
    public var clientId: String
    public var code: String
    public var redirectUri: String
    public var codeVerifier: String
    public var clientSecret: String?
    public var authMethod: OAuthTokenEndpointAuthMethod
    
    public init(
        clientId: String,
        code: String,
        redirectUri: String,
        codeVerifier: String,
        clientSecret: String? = nil,
        authMethod: OAuthTokenEndpointAuthMethod = .none
    ) {
        self.clientId = clientId
        self.code = code
        self.redirectUri = redirectUri
        self.codeVerifier = codeVerifier
        self.clientSecret = clientSecret
        self.authMethod = authMethod
    }
}

/// Refresh an access token (rotating refresh tokens).
public struct OAuthRefreshTokenRequest {
    public var clientId: String
    public var refreshToken: String
    public var clientSecret: String?
    public var scope: String?
    public var authMethod: OAuthTokenEndpointAuthMethod
    
    public init(
        clientId: String,
        refreshToken: String,
        clientSecret: String? = nil,
        scope: String? = nil,
        authMethod: OAuthTokenEndpointAuthMethod = .none
    ) {
        self.clientId = clientId
        self.refreshToken = refreshToken
        self.clientSecret = clientSecret
        self.scope = scope
        self.authMethod = authMethod
    }
}

public struct OAuthTokenResponse: Decodable, Equatable {
    public var accessToken: String
    public var tokenType: String
    public var expiresIn: Int
    public var refreshToken: String?
    public var scope: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
    }
}

struct OAuthErrorResponse: Decodable {
    var error: String
    var errorDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}
