//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 6/9/24.
//

import Foundation

extension EmailAddress {
    init(from string: String) {
        if let start = string.firstIndex(of: "<"), let end = string.firstIndex(of: ">"), start < end {
            self.name = String(string[..<start]).trimmingCharacters(in: .whitespaces)
            self.email = String(string[string.index(after: start)..<end])
        } else {
            self.email = string
            self.name = nil
        }
    }
}
