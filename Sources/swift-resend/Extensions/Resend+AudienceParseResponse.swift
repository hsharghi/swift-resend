//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/9/24.
//

import NIO
import AsyncHTTPClient
import NIOFoundationCompat

extension AudienceClient {
    
    func parseCreateResponse(_ response: HTTPClient.Response) throws -> AudienceCreateResponse {
        let byteBuffer: ByteBuffer = response.body ?? .init()
        
        if response.status == .ok {
            return try decodeResponse(AudienceCreateResponse.self, from: byteBuffer)
        } else {
            let errorResponse = try decodeResponse(ErrorResponse.self, from: byteBuffer)
            try parseErrorResponse(errorResponse)
        }
    }
    
    func parseContactListResponse(_ response: HTTPClient.Response) throws -> [Audience] {
        let byteBuffer: ByteBuffer = response.body ?? .init()
        
        if response.status == .ok {
            do {
                let list = try decodeResponse(AudienceListResponse.self, from: byteBuffer)
                return list.data
            } catch {
                throw ResendError.decodingError("Failed to decode\n \(String(buffer: byteBuffer)) to \(String(describing: AudienceListResponse.self))")
            }
        } else {
            let errorResponse = try decodeResponse(ErrorResponse.self, from: byteBuffer)
            try parseErrorResponse(errorResponse)
        }

    }
    
}
