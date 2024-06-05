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
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    public init(httpClient: HTTPClient, apiKey: String) {
        self.httpClient = httpClient
        self.apiKey = apiKey
    }
    
    public var emails: EmailClient {
        EmailClient(httpClient: httpClient, apiKey: apiKey)
    }    
}
