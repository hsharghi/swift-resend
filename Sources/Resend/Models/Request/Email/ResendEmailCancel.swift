//
//  EmailUpdate.swift
//  swift-resend
//
//  Created by Hadi Sharghi on 7/2/25.
//


import Foundation

struct ResendEmailCancel: Encodable {
    
    /// Id of the email to be deleted.
    /// Id is a UUID string
    public var id: String

    public init(id: String)
    {
        self.id = id
    }

}
