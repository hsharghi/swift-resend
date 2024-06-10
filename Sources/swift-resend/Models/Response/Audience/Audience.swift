//
//  Audience.swift
//
//
//  Created by Hadi Sharghi on 6/10/24.
//

import Foundation

public struct Audience: Decodable {
    public var id: String
    public var object: ResendObject
    public var name: String
    public var createdAt: Date

    init(id: String, object: ResendObject = .audience, name: String, createdAt: Date) {
        self.id = id
        self.object = object
        self.name = name
        self.createdAt = createdAt
    }
}
