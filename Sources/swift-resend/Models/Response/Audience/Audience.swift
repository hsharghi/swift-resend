//
//  Audience.swift
//
//
//  Created by Hadi Sharghi on 6/10/24.
//

import Foundation

public struct Audience: Decodable {
    public var id: String
    public var name: String
    public var createdAt: Date

    init(id: String, name: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
    }
}
