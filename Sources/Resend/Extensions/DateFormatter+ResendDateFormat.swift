//
//  DateFormatter+ResendDateFormat.swift
//  swift-resend
//
//  Created by Hadi Sharghi on 12/16/25.
//

import Foundation


extension DateFormatter {
    static let resendReceivedEmailDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        return formatter
    }()
    
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        return formatter
    }()
}
