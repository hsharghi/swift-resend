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

public class ResendClient {
    
    let apiURL = "https://api.resend.com"
    let httpClient: HTTPClient
    let apiKey: String
    
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
         encoder.dateEncodingStrategy = .secondsSince1970
         return encoder
    }()
    
    let decoder: JSONDecoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()

    public init(httpClient: HTTPClient, apiKey: String) {
        self.httpClient = httpClient
        self.apiKey = apiKey
    }
    
    public func getAuthHeader() -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer \(apiKey)")
        headers.add(name: "Content-Type", value: "application/json")
        return headers
    }
    
    public var emails: EmailClient {
        EmailClient(httpClient: httpClient, apiKey: apiKey)
    }    
}
