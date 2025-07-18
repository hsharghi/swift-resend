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
    case cancleSchedule(emailId: String)
    case audienceCreate
    case audienceGet(audienceId: String)
    case audienceDelete(audienceId: String)
    case audienceList
    case contactAdd(audienceId: String)
    case contactGet(contactId: String, audienceId: String)
    case contactUpdate(contactId: String, audienceId: String)
    case contactDelete(contactIdOrEmail: String, audienceId: String)
    case contactList(audienceId: String)
    case apiKeyCreate
    case apiKeyList
    case apiKeyDelete(apiKeyId: String)
    case domainCreate
    case domainRetrieve(domainId: String)
    case domainVerify(domainId: String)
    case domainUpdate(domainId: String)
    case domainList
    case domainDelete(domainId: String)
    case broadcastCreate
    case broadcastGet(broadcastId: String)
    case broadcastUpdate(broadcastId: String)
    case broadcastSend(broadcastId: String)
    case broadcastDelete(broadcastId: String)
    case broadcastList
    
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
        case .cancleSchedule(let emailId):
            return path(of: "/emails/\(emailId)/cancel")
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
        case .apiKeyCreate:
            return path(of: "/api-keys")
        case .apiKeyList:
            return path(of: "/api-keys")
        case .apiKeyDelete(let apiKeyId):
            return path(of: "/api-keys/\(apiKeyId)")
        case .domainCreate:
            return path(of: "/domains")
        case .domainRetrieve(let domainId):
            return path(of: "/domains/\(domainId)")
        case .domainVerify(let domainId):
            return path(of: "/domains/\(domainId)/verify")
        case .domainUpdate(let domainId):
            return path(of: "/domains/\(domainId)")
        case .domainList:
            return path(of: "/domains")
        case .domainDelete(let domainId):
            return path(of: "/domains/\(domainId)")
        case .broadcastCreate:
            return path(of: "/broadcasts")
        case .broadcastGet(let broadcastId):
            return path(of: "/broadcasts/\(broadcastId)")
        case .broadcastUpdate(let broadcastId):
            return path(of: "/broadcasts/\(broadcastId)")
        case .broadcastSend(let broadcastId):
            return path(of: "/broadcasts/\(broadcastId)/send")
        case .broadcastDelete(let broadcastId):
            return path(of: "/broadcasts/\(broadcastId)")
        case .broadcastList:
            return path(of: "/broadcasts")
        }
    }
}
