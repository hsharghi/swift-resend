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
    
    func parseBatchSentResponse(_ response: HTTPClient.Response) throws -> [EmailSentResponse] {
        let byteBuffer: ByteBuffer = response.body ?? .init()
        
        if response.status == .ok {
            let res = try decodeResponse(EmailSentBatchResponse.self, from: byteBuffer)
            return res.data.map { EmailSentResponse(id: $0.id) }
        } else {
            let errorResponse = try decodeResponse(ErrorResponse.self, from: byteBuffer)
            try parseErrorResponse(errorResponse)
        }
    }
    
    func parseGetResponse(_ response: HTTPClient.Response) throws -> EmailGetResponse {
        let byteBuffer: ByteBuffer = response.body ?? .init()
        
        if response.status == .ok {
            return try decodeResponse(EmailGetResponse.self, from: byteBuffer)
        } else {
            let errorResponse = try decodeResponse(ErrorResponse.self, from: byteBuffer)
            try parseErrorResponse(errorResponse)
        }
    }
    
}
