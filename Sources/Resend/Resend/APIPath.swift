//
//  File.swift
//  
//
//  Created by Hadi Sharghi on 6/12/24.
//

import Foundation

enum APIPath {
    
    private static var apiURL: String {
        "https://api.resend.com"
    }

    case emailSend
    case emailBatchSend
    case emailGet(emailId: String)
    case audienceCreate
    case audienceGet(audienceId: String)
    case audienceDelete(audienceId: String)
    case audienceList
    case contactAdd(audienceId: String)
    case contactGet(contactId: String, audienceId: String)
    case contactUpdate(contactId: String, audienceId: String)
    case contactDelete(contactIdOrEmail: String, audienceId: String)
    case contactList(audienceId: String)
    
    private static func path(of path: String) -> String {
        APIPath.apiURL + path
    }
    
    static func getPath(for: APIPath) -> String {
        switch `for` {
        case .emailSend:
            return path(of: "/emails")
        case .emailBatchSend:
            return path(of: "/emails/batch")
        case .emailGet(let emailId):
            return path(of: "/emails/\(emailId)")
        case .audienceCreate:
            return path(of: "/audiences")
        case .audienceGet(let audienceId):
            return path(of: "/audiences/\(audienceId)")
        case .audienceDelete(let audienceId):
            return path(of: "/audiences/\(audienceId)")
        case .audienceList:
            return path(of: "/audiences")
        case .contactAdd(audienceId: let audienceId):
            return path(of: "/audiences/\(audienceId)/contacts")
        case .contactGet(contactId: let contactId, audienceId: let audienceId):
            return path(of: "/audiences/\(audienceId)/contacts/\(contactId)")
        case .contactUpdate(contactId: let contactId, audienceId: let audienceId):
            return path(of: "/audiences/\(audienceId)/contacts/\(contactId)")
        case .contactDelete(contactIdOrEmail: let contactIdOrEmail, audienceId: let audienceId):
            return path(of: "/audiences/\(audienceId)/contacts/\(contactIdOrEmail)")
        case .contactList(let audienceId):
            return path(of: "/audiences/\(audienceId)/contacts")
        }
    }
}
