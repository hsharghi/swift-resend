//
//  EmailEvents.swift
//  swift-resend
//
//  Created by Hadi Sharghi on 12/15/25.
//

import Foundation

public enum EmailEvents: String, Decodable {
    case bounced
    case canceled
    case complained
    case delivered
    case deliveryDelayed = "delivery_delayed"
    case failed
    case opened
    case queued
    case scheduled
    case sent
    
}
