//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 2024-06-10.
//

import Foundation

public struct ContactListResponse: Decodable {
    public var data: [ResendContact]
    
    init(data: [ResendContact]) {
        self.data = data
    }
}

