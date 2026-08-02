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
    case cancelSchedule(emailId: String)
    case emailList(limit: Int, after: String?, before: String?)
    case attachmentList(emailId: String, limit: Int, after: String?, before: String?)
    case attachmentGet(attachmentId: String, emailId: String)
    case emailReceivingList(limit: Int, after: String?, before: String?)
    case emailReceivingGet(emailId: String)
    case emailReceivingAttachmentList(emailId: String, limit: Int, after: String?, before: String?)
    case emailReceivingAttachmentGet(attachmentId: String, emailId: String)
    case audienceCreate
    case audienceGet(audienceId: String)
    case audienceDelete(audienceId: String)
    case audienceList
    case contactAdd(audienceId: String)
    case contactGet(contactId: String, audienceId: String)
    case contactUpdate(contactId: String, audienceId: String)
    case contactDelete(contactIdOrEmail: String, audienceId: String)
    case contactListAudience(audienceId: String)
    case apiKeyCreate
    case apiKeyList
    case apiKeyDelete(apiKeyId: String)
    case domainCreate
    case domainRetrieve(domainId: String)
    case domainVerify(domainId: String)
    case domainUpdate(domainId: String)
    case domainList
    case domainDelete(domainId: String)
    case domainClaimCreate
    case domainClaimGet(domainId: String)
    case domainClaimVerify(domainId: String)
    case broadcastCreate
    case broadcastGet(broadcastId: String)
    case broadcastUpdate(broadcastId: String)
    case broadcastSend(broadcastId: String)
    case broadcastDelete(broadcastId: String)
    case broadcastList
    case segmentCreate
    case segmentList(limit: Int, after: String?, before: String?)
    case segmentGet(segmentId: String)
    case segmentDelete(segmentId: String)
    case topicCreate
    case topicList(limit: Int, after: String?, before: String?)
    case topicGet(topicId: String)
    case topicUpdate(topicId: String)
    case topicDelete(topicId: String)
    case contactCreate
    case contactList(segmentId: String?, limit: Int, after: String?, before: String?)
    case contactGetGlobal(idOrEmail: String)
    case contactUpdateGlobal(idOrEmail: String)
    case contactDeleteGlobal(idOrEmail: String)
    case contactSegmentsList(contactId: String, limit: Int, after: String?, before: String?)
    case contactSegmentAdd(contactId: String, segmentId: String)
    case contactSegmentRemove(contactId: String, segmentId: String)
    case contactTopicsList(contactId: String, limit: Int, after: String?, before: String?)
    case contactTopicsUpdate(contactId: String)
    case eventCreate
    case eventList(limit: Int, after: String?, before: String?)
    case eventGet(identifier: String)
    case eventUpdate(identifier: String)
    case eventDelete(identifier: String)
    case eventSend
    case automationCreate
    case automationList(status: String?, limit: Int, after: String?, before: String?)
    case automationGet(automationId: String)
    case automationUpdate(automationId: String)
    case automationDelete(automationId: String)
    case automationStop(automationId: String)
    case automationRunsList(automationId: String, status: String?, limit: Int, after: String?, before: String?)
    case automationRunGet(automationId: String, runId: String)
    case templateCreate
    case templateList(limit: Int, after: String?, before: String?)
    case templateGet(idOrAlias: String)
    case templateUpdate(idOrAlias: String)
    case templateDelete(idOrAlias: String)
    case templatePublish(idOrAlias: String)
    case templateDuplicate(idOrAlias: String)
    case webhookCreate
    case webhookList(limit: Int, after: String?, before: String?)
    case webhookGet(webhookId: String)
    case webhookUpdate(webhookId: String)
    case webhookDelete(webhookId: String)
    case suppressionAdd
    case suppressionList(origin: String?, limit: Int, after: String?, before: String?)
    case suppressionGet(idOrEmail: String)
    case suppressionRemove(idOrEmail: String)
    case suppressionBatchAdd
    case suppressionBatchRemove
    case contactPropertyCreate
    case contactPropertyList(limit: Int, after: String?, before: String?)
    case contactPropertyGet(propertyId: String)
    case contactPropertyUpdate(propertyId: String)
    case contactPropertyDelete(propertyId: String)
    case logList(limit: Int, after: String?, before: String?)
    case logGet(logId: String)
    case oauthGrantList(limit: Int, after: String?, before: String?)
    case oauthGrantRevoke(grantId: String)
    case oauthToken
    case contactImportCreate
    case contactImportList(status: String?, limit: Int, after: String?, before: String?)
    case contactImportGet(importId: String)
    
    private static func path(of path: String) -> String {
        APIPath.apiURL + path
    }
    
    private static func appendPagination(_ path: inout String, after: String?, before: String?) {
        if let after {
            path += "&after=\(after)"
        }
        if let before {
            path += "&before=\(before)"
        }
    }
    
    /// Encodes path components that may contain `@` (email addresses).
    private static func encodePathComponent(_ value: String) -> String {
        var allowed = CharacterSet.urlPathAllowed
        allowed.remove(charactersIn: "@")
        return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
    }
    
    static func getPath(for: APIPath) -> String {
        switch `for` {
        case .emailSend:
            return path(of: "/emails")
        case .emailBatchSend:
            return path(of: "/emails/batch")
        case .emailGet(let emailId):
            return path(of: "/emails/\(emailId)")
        case .cancelSchedule(let emailId):
            return path(of: "/emails/\(emailId)/cancel")
        case .emailList(limit: let limit, after: let after, before: let before):
            var path = path(of: "/emails?limit=\(limit)")
            if let after {
                path += "&after=\(after)"
            }
            if let before {
                path += "&before=\(before)"
            }
            return path
        case .attachmentList(emailId: let emailId, limit: let limit, after: let after, before: let before):
            var path = path(of: "/emails/\(emailId)/attachments?limit=\(limit)")
            if let after {
                path += "&after=\(after)"
            }
            if let before {
                path += "&before=\(before)"
            }
            return path
        case .attachmentGet(attachmentId: let attachmentId, emailId: let emailId):
            return path(of: "/emails/\(emailId)/attachments/\(attachmentId)")
        case .emailReceivingList(limit: let limit, after: let after, before: let before):
            var path = path(of: "/emails/receiving?limit=\(limit)")
            if let after {
                path += "&after=\(after)"
            }
            if let before {
                path += "&before=\(before)"
            }
            return path
        case .emailReceivingGet(let emailId):
            return path(of: "/emails/receiving/\(emailId)")
        case .emailReceivingAttachmentList(emailId: let emailId, limit: let limit, after: let after, before: let before):
            var path = path(of: "/emails/receiving/\(emailId)/attachments?limit=\(limit)")
            if let after {
                path += "&after=\(after)"
            }
            if let before {
                path += "&before=\(before)"
            }
            return path
        case .emailReceivingAttachmentGet(attachmentId: let attachmentId, emailId: let emailId):
            return path(of: "/emails/receiving/\(emailId)/attachments/\(attachmentId)")
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
            return path(of: "/audiences/\(audienceId)/contacts/\(encodePathComponent(contactIdOrEmail))")
        case .contactListAudience(let audienceId):
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
        case .domainClaimCreate:
            return path(of: "/domains/claim")
        case .domainClaimGet(let domainId):
            return path(of: "/domains/\(domainId)/claim")
        case .domainClaimVerify(let domainId):
            return path(of: "/domains/\(domainId)/claim/verify")
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
        case .segmentCreate:
            return path(of: "/segments")
        case .segmentList(limit: let limit, after: let after, before: let before):
            var path = path(of: "/segments?limit=\(limit)")
            appendPagination(&path, after: after, before: before)
            return path
        case .segmentGet(let segmentId):
            return path(of: "/segments/\(segmentId)")
        case .segmentDelete(let segmentId):
            return path(of: "/segments/\(segmentId)")
        case .topicCreate:
            return path(of: "/topics")
        case .topicList(limit: let limit, after: let after, before: let before):
            var path = path(of: "/topics?limit=\(limit)")
            appendPagination(&path, after: after, before: before)
            return path
        case .topicGet(let topicId):
            return path(of: "/topics/\(topicId)")
        case .topicUpdate(let topicId):
            return path(of: "/topics/\(topicId)")
        case .topicDelete(let topicId):
            return path(of: "/topics/\(topicId)")
        case .contactCreate:
            return path(of: "/contacts")
        case .contactList(segmentId: let segmentId, limit: let limit, after: let after, before: let before):
            var path = path(of: "/contacts?limit=\(limit)")
            if let segmentId {
                path += "&segment_id=\(segmentId)"
            }
            appendPagination(&path, after: after, before: before)
            return path
        case .contactGetGlobal(let idOrEmail):
            return path(of: "/contacts/\(encodePathComponent(idOrEmail))")
        case .contactUpdateGlobal(let idOrEmail):
            return path(of: "/contacts/\(encodePathComponent(idOrEmail))")
        case .contactDeleteGlobal(let idOrEmail):
            return path(of: "/contacts/\(encodePathComponent(idOrEmail))")
        case .contactSegmentsList(contactId: let contactId, limit: let limit, after: let after, before: let before):
            var path = path(of: "/contacts/\(encodePathComponent(contactId))/segments?limit=\(limit)")
            appendPagination(&path, after: after, before: before)
            return path
        case .contactSegmentAdd(contactId: let contactId, segmentId: let segmentId):
            return path(of: "/contacts/\(encodePathComponent(contactId))/segments/\(segmentId)")
        case .contactSegmentRemove(contactId: let contactId, segmentId: let segmentId):
            return path(of: "/contacts/\(encodePathComponent(contactId))/segments/\(segmentId)")
        case .contactTopicsList(contactId: let contactId, limit: let limit, after: let after, before: let before):
            var path = path(of: "/contacts/\(encodePathComponent(contactId))/topics?limit=\(limit)")
            appendPagination(&path, after: after, before: before)
            return path
        case .contactTopicsUpdate(let contactId):
            return path(of: "/contacts/\(encodePathComponent(contactId))/topics")
        case .eventCreate:
            return path(of: "/events")
        case .eventList(limit: let limit, after: let after, before: let before):
            var path = path(of: "/events?limit=\(limit)")
            appendPagination(&path, after: after, before: before)
            return path
        case .eventGet(let identifier):
            return path(of: "/events/\(encodePathComponent(identifier))")
        case .eventUpdate(let identifier):
            return path(of: "/events/\(encodePathComponent(identifier))")
        case .eventDelete(let identifier):
            return path(of: "/events/\(encodePathComponent(identifier))")
        case .eventSend:
            return path(of: "/events/send")
        case .automationCreate:
            return path(of: "/automations")
        case .automationList(status: let status, limit: let limit, after: let after, before: let before):
            var path = path(of: "/automations?limit=\(limit)")
            if let status {
                path += "&status=\(status)"
            }
            appendPagination(&path, after: after, before: before)
            return path
        case .automationGet(let automationId):
            return path(of: "/automations/\(automationId)")
        case .automationUpdate(let automationId):
            return path(of: "/automations/\(automationId)")
        case .automationDelete(let automationId):
            return path(of: "/automations/\(automationId)")
        case .automationStop(let automationId):
            return path(of: "/automations/\(automationId)/stop")
        case .automationRunsList(automationId: let automationId, status: let status, limit: let limit, after: let after, before: let before):
            var path = path(of: "/automations/\(automationId)/runs?limit=\(limit)")
            if let status {
                path += "&status=\(status)"
            }
            appendPagination(&path, after: after, before: before)
            return path
        case .automationRunGet(automationId: let automationId, runId: let runId):
            return path(of: "/automations/\(automationId)/runs/\(runId)")
        case .templateCreate:
            return path(of: "/templates")
        case .templateList(limit: let limit, after: let after, before: let before):
            var path = path(of: "/templates?limit=\(limit)")
            appendPagination(&path, after: after, before: before)
            return path
        case .templateGet(let idOrAlias):
            return path(of: "/templates/\(encodePathComponent(idOrAlias))")
        case .templateUpdate(let idOrAlias):
            return path(of: "/templates/\(encodePathComponent(idOrAlias))")
        case .templateDelete(let idOrAlias):
            return path(of: "/templates/\(encodePathComponent(idOrAlias))")
        case .templatePublish(let idOrAlias):
            return path(of: "/templates/\(encodePathComponent(idOrAlias))/publish")
        case .templateDuplicate(let idOrAlias):
            return path(of: "/templates/\(encodePathComponent(idOrAlias))/duplicate")
        case .webhookCreate:
            return path(of: "/webhooks")
        case .webhookList(limit: let limit, after: let after, before: let before):
            var path = path(of: "/webhooks?limit=\(limit)")
            appendPagination(&path, after: after, before: before)
            return path
        case .webhookGet(let webhookId):
            return path(of: "/webhooks/\(webhookId)")
        case .webhookUpdate(let webhookId):
            return path(of: "/webhooks/\(webhookId)")
        case .webhookDelete(let webhookId):
            return path(of: "/webhooks/\(webhookId)")
        case .suppressionAdd:
            return path(of: "/suppressions")
        case .suppressionList(origin: let origin, limit: let limit, after: let after, before: let before):
            var path = path(of: "/suppressions?limit=\(limit)")
            if let origin {
                path += "&origin=\(origin)"
            }
            appendPagination(&path, after: after, before: before)
            return path
        case .suppressionGet(let idOrEmail):
            return path(of: "/suppressions/\(encodePathComponent(idOrEmail))")
        case .suppressionRemove(let idOrEmail):
            return path(of: "/suppressions/\(encodePathComponent(idOrEmail))")
        case .suppressionBatchAdd:
            return path(of: "/suppressions/batch/add")
        case .suppressionBatchRemove:
            return path(of: "/suppressions/batch/remove")
        case .contactPropertyCreate:
            return path(of: "/contact-properties")
        case .contactPropertyList(limit: let limit, after: let after, before: let before):
            var path = path(of: "/contact-properties?limit=\(limit)")
            appendPagination(&path, after: after, before: before)
            return path
        case .contactPropertyGet(let propertyId):
            return path(of: "/contact-properties/\(propertyId)")
        case .contactPropertyUpdate(let propertyId):
            return path(of: "/contact-properties/\(propertyId)")
        case .contactPropertyDelete(let propertyId):
            return path(of: "/contact-properties/\(propertyId)")
        case .logList(limit: let limit, after: let after, before: let before):
            var path = path(of: "/logs?limit=\(limit)")
            appendPagination(&path, after: after, before: before)
            return path
        case .logGet(let logId):
            return path(of: "/logs/\(logId)")
        case .oauthGrantList(limit: let limit, after: let after, before: let before):
            var path = path(of: "/oauth/grants?limit=\(limit)")
            appendPagination(&path, after: after, before: before)
            return path
        case .oauthGrantRevoke(let grantId):
            return path(of: "/oauth/grants/\(grantId)")
        case .oauthToken:
            return path(of: "/oauth/token")
        case .contactImportCreate:
            return path(of: "/contacts/imports")
        case .contactImportList(status: let status, limit: let limit, after: let after, before: let before):
            var path = path(of: "/contacts/imports?limit=\(limit)")
            if let status {
                path += "&status=\(status)"
            }
            appendPagination(&path, after: after, before: before)
            return path
        case .contactImportGet(let importId):
            return path(of: "/contacts/imports/\(importId)")
        }
    }
}
