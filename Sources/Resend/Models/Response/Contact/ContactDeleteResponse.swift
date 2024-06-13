//
//  File.swift
//
//
//  Created by Hadi Sharghi on 2024-06-10.
//

import Foundation

public struct ContactDeleteResponse: Decodable {
    public var contact: String
    public var deleted: Bool
    
    init(contact: String, deleted: Bool) {
        self.contact = contact
        self.deleted = deleted
    }
}
