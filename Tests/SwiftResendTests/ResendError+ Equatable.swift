//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 2024-06-10.
//

import Foundation
@testable import Resend

extension ResendError: Equatable {
    public static func == (lhs: ResendError, rhs: ResendError) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
