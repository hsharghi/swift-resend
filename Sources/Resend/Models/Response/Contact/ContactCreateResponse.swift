//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 2024-06-10.
//

import Foundation

public struct ContactCreateResponse: Decodable {
    public var id: String
    
    init(id: String) {
        self.id = id
    }
}
