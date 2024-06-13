//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 6/10/24.
//

import Foundation

public struct AudienceCreateResponse: Decodable {
    public var id: String
    public var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
