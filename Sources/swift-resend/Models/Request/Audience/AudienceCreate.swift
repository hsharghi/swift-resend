//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 6/10/24.
//

import Foundation

struct AudienceCreate: Encodable {
    
    /// The name of the audience you want to create.
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
