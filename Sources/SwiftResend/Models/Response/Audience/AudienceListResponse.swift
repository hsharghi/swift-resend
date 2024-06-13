//
//  File.swift
//
//
//  Created by Hadi Sharghi on 2024-06-10.
//

import Foundation

public struct AudienceListResponse: Decodable {
    public var data: [Audience]
    
    init(data: [Audience]) {
        self.data = data
    }
}

