//
//  File.swift
//
//
//  Created by Hadi Sharghi on 6/12/24.
//

import Foundation

struct ContactUpdate: Encodable {
    var firstName: String?
    var lastName: String?
    var subscriptionStatus: Bool?
    
    init(firstName: String? = nil,
         lastName: String? = nil,
         subscriptionStatus: Bool? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.subscriptionStatus = subscriptionStatus != nil ? !subscriptionStatus! : subscriptionStatus
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case subscriptionStatus = "unsubscribed"
    }

}
