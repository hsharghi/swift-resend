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

public struct ResendClient {
    
    let apiURL = "https://api.resend.com"
    let httpClient: HTTPClient
    let apiKey: String
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
         encoder.dateEncodingStrategy = .secondsSince1970
         return encoder
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    public init(httpClient: HTTPClient, apiKey: String) {
        self.httpClient = httpClient
        self.apiKey = apiKey
    }
    
    public func send(email: ResendEmail) async throws -> EmailSentResponse {
                
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer \(apiKey)")
        headers.add(name: "Content-Type", value: "application/json")
        
        email.headers?.forEach({ emailHeader in
            headers.add(name: emailHeader.name, value: emailHeader.value ?? "")
        })
        
        let response = try await httpClient.execute(
            request: .init(
                url: apiURL + "/email",
                method: .POST,
                headers: headers,
                body: .data(encoder.encode(email))
            )
        ).get()
        
        let byteBuffer = response.body ?? ByteBuffer(.init())
        switch response.status {
        case .ok:
            let res = try decoder.decode(EmailSentResponse.self, from: byteBuffer)
            return .init(id: res.id)
        default:
            let errorResponse = try decoder.decode(ErrorResponse.self, from: byteBuffer)
            return .init(error: errorResponse)
            
        }

    }
}
