//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 6/10/24.
//

import Foundation

public struct AudienceDeleteResponse: Decodable {
    public var id: String
    public var deleted: Bool

    init(id: String, deleted: Bool) {
        self.id = id
        self.deleted = deleted
    }
}
