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

public class EmailClient: ResendClient {
    
    public func send(email: ResendEmail) async throws -> EmailSentResponse {
        
        
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer \(apiKey)")
        headers.add(name: "Content-Type", value: "application/json")
        
        email.headers?.forEach({ emailHeader in
            headers.add(name: emailHeader.name, value: emailHeader.value ?? "")
        })
        
        let enc = try encoder.encode(email)
        print(String(data: enc, encoding: .utf8))
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
