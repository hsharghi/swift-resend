//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 2024-06-10.
//

import Foundation

public struct ContactCreateResponse: Decodable {
    public var object: String
    public var id: String
    
    init(object: String = "contact", id: String) {
        self.object = object
        self.id = id
    }
}
