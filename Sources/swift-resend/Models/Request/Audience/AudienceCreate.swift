//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 6/10/24.
//

import Foundation

struct AudienceCreate: Encodable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
