//
//  File.swift
//
//
//  Created by Hadi Sharghi on 2024-06-10.
//

import Foundation

public struct ContactDeleteResponse: Decodable {
    public var object: String
    public var contact: String
    public var deleted: Bool
    
    init(object: String = "contact", contact: String, deleted: Bool) {
        self.object = object
        self.contact = contact
        self.deleted = deleted
    }
}
