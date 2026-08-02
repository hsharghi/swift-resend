import Foundation
import AsyncHTTPClient
import NIOHTTP1
import NIOFoundationCompat

/// OAuth protocol helpers (token exchange / refresh).
///
/// These calls do **not** use the team API key. Authentication is via `client_id`
/// (and optionally `client_secret`) plus PKCE for authorization-code grants.
public class OAuthClient: ResendClient {
    
    internal override init(httpClient: HTTPClient, apiKey: String) {
        super.init(httpClient: httpClient, apiKey: apiKey)
    }
    
    /// Exchange an authorization code for access and refresh tokens (authorization_code + PKCE).
    public func token(_ request: OAuthAuthorizationCodeTokenRequest) async throws -> OAuthTokenResponse {
        var params: [(String, String)] = [
            ("grant_type", "authorization_code"),
            ("code", request.code),
            ("redirect_uri", request.redirectUri),
            ("code_verifier", request.codeVerifier)
        ]
        
        let headers = try oauthFormHeaders(
            clientId: request.clientId,
            clientSecret: request.clientSecret,
            authMethod: request.authMethod,
            bodyParams: &params
        )
        
        return try await postToken(params: params, headers: headers)
    }
    
    /// Refresh an access token (refresh_token grant; refresh tokens rotate on each use).
    public func token(_ request: OAuthRefreshTokenRequest) async throws -> OAuthTokenResponse {
        var params: [(String, String)] = [
            ("grant_type", "refresh_token"),
            ("refresh_token", request.refreshToken)
        ]
        if let scope = request.scope {
            params.append(("scope", scope))
        }
        
        let headers = try oauthFormHeaders(
            clientId: request.clientId,
            clientSecret: request.clientSecret,
            authMethod: request.authMethod,
            bodyParams: &params
        )
        
        return try await postToken(params: params, headers: headers)
    }
    
    private func postToken(params: [(String, String)], headers: HTTPHeaders) async throws -> OAuthTokenResponse {
        let body = Self.encodeFormURLEncoded(params)
        let response = try await httpClient.execute(
            request: .init(
                url: APIPath.getPath(for: .oauthToken),
                method: .POST,
                headers: headers,
                body: .data(body)
            )
        ).get()
        
        return try parseOAuthTokenResponse(response)
    }
    
    private func oauthFormHeaders(
        clientId: String,
        clientSecret: String?,
        authMethod: OAuthTokenEndpointAuthMethod,
        bodyParams: inout [(String, String)]
    ) throws -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/x-www-form-urlencoded")
        
        switch authMethod {
        case .none:
            bodyParams.insert(("client_id", clientId), at: 0)
            if clientSecret != nil {
                throw ResendError.validationError(
                    "Public clients (authMethod: .none) must not supply a client secret. Use .clientSecretPost or .clientSecretBasic."
                )
            }
        case .clientSecretPost:
            guard let clientSecret else {
                throw ResendError.validationError("clientSecret is required for authMethod: .clientSecretPost.")
            }
            bodyParams.insert(("client_id", clientId), at: 0)
            bodyParams.append(("client_secret", clientSecret))
        case .clientSecretBasic:
            guard let clientSecret else {
                throw ResendError.validationError("clientSecret is required for authMethod: .clientSecretBasic.")
            }
            // RFC 6749: URL-encode client_id and client_secret, join with :, then Base64.
            let user = Self.formURLEncode(clientId)
            let pass = Self.formURLEncode(clientSecret)
            let credentials = Data("\(user):\(pass)".utf8).base64EncodedString()
            headers.add(name: "Authorization", value: "Basic \(credentials)")
        }
        
        return headers
    }
    
    private func parseOAuthTokenResponse(_ response: HTTPClient.Response) throws -> OAuthTokenResponse {
        let byteBuffer = response.body ?? .init()
        
        if response.status == .ok {
            return try decodeResponse(OAuthTokenResponse.self, from: byteBuffer)
        }
        
        if let oauthError = try? decodeResponse(OAuthErrorResponse.self, from: byteBuffer) {
            let description = oauthError.errorDescription ?? oauthError.error
            switch oauthError.error {
            case "invalid_scope":
                throw ResendError.invalidScope(description)
            case "invalid_client":
                throw ResendError.invalidApiKey(description)
            default:
                throw ResendError.validationError("\(oauthError.error): \(description)")
            }
        }
        
        // Fall back to standard Resend error shape when present.
        let errorResponse = try decodeResponse(ErrorResponse.self, from: byteBuffer)
        try parseErrorResponse(errorResponse)
    }
    
    private static func encodeFormURLEncoded(_ params: [(String, String)]) -> Data {
        let encoded = params
            .map { "\(formURLEncode($0.0))=\(formURLEncode($0.1))" }
            .joined(separator: "&")
        return Data(encoded.utf8)
    }
    
    private static func formURLEncode(_ string: String) -> String {
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "-._~")
        return string.addingPercentEncoding(withAllowedCharacters: allowed) ?? string
    }
}
