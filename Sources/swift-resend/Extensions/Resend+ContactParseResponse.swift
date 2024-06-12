//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/9/24.
//

import NIO
import AsyncHTTPClient
import NIOFoundationCompat

extension ContactClient {
    
    func parseContactListResponse(_ response: HTTPClient.Response) throws -> [ResendContact] {
        let byteBuffer: ByteBuffer = response.body ?? .init()
        
        if response.status == .ok {
            do {
                let list = try decodeResponse(ContactListResponse.self, from: byteBuffer)
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
