//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/12/24.
//

import Foundation

struct ContactCreate: Encodable {
    var email: String
    var firstName: String?
    var lastName: String?
    var subscriptionStatus: Bool
    
    init(email: String,
         firstName: String? = nil,
         lastName: String? = nil,
         subscriptionStatus: Bool = true) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.subscriptionStatus = !subscriptionStatus
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case subscriptionStatus = "unsubscribed"
    }
}
