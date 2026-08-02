import XCTest
import AsyncHTTPClient
@testable import Resend

final class SwiftResendTests: XCTestCase {
    
    private var httpClient: HTTPClient!
    private var resend: ResendClient!
    
    
    override func setUp() {
        httpClient = HTTPClient(eventLoopGroupProvider: .singleton)
        
        // TODO: Replace with your API key to test!
        resend = ResendClient(httpClient: httpClient, apiKey: "YOUR-API-KEY")
    }
    
    override func tearDown() async throws {
        try await httpClient.shutdown()
    }
    
    
    func testEmailAddressFromString() {
        let email1: EmailAddress = "hadi<hadi123@example.com>"
        XCTAssertEqual(email1.email, "hadi123@example.com")
        XCTAssertEqual(email1.name, "hadi")
    }
    
    func testSend() async throws {
        let id = try await resend.emails.send(email: ResendEmail(
            from: EmailAddress(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "running xctest",
            replyTo: [
                "hadi@example.com",
                "manager@example.com",
                EmailAddress(email: "sales@example.com", name: "John")
            ],
            text: "sending email from XCTest suit",
            headers: [
                EmailHeaders(name: "X-Entity-Ref-ID", value: "234H3-44"),
                EmailHeaders(name: "X-Entity-Dep-ID", value: "SALE-03"),
            ],
            attachments: [
                EmailAttachment(filePath: "path/to/a/file"),
                EmailAttachment(content: .init(data: .init(contentsOf: .init(filePath: "path/to/a/file"))), filename: "sales.xlsx")
            ],
            tags: [
                EmailTags(name: "priority", value: "medium"),
                EmailTags(name: "department", value: "sales")
            ]
        ))
        XCTAssertNotNil(id)
    }
    
    func testSendWithScheduleInNaturalLanuguage() async throws {
        let id = try await resend.emails.send(email: .init(
            from: .init(email: "hadi@softworks.ir", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "send later",
            scheduledAt: "in an hour",
            text: "sending email from XCTest suit with schedule",
        ))
        XCTAssertNotNil(id)
        
        let info = try await resend.emails.get(emailId: id)
        XCTAssertEqual(.scheduled, info.lastEvent)
    }
    
    func testSendWithScheduleWithDate() async throws {
        let id = try await resend.emails.send(email: .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "send later",
            scheduledAt: .date(Date(timeIntervalSinceNow: 60*60)),
            text: "sending email from XCTest suit with schedule",
        ))
        XCTAssertNotNil(id)
        
        let info = try await resend.emails.get(emailId: id)
        XCTAssertEqual(.scheduled, info.lastEvent)
    }
    
    
    func testUpdateScheduledEmail() async throws {
        let id = try await resend.emails.send(email: .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "send later",
            scheduledAt: .date(Date(timeIntervalSinceNow: 60*60)),
            text: "sending email from XCTest suit with schedule",
        ))
        
        let id2 = try await resend.emails.update(emailId: id, scheduledAt: "in three hours")
        XCTAssertEqual(id, id2)
        
        let info = try await resend.emails.get(emailId: id)
        XCTAssertEqual(.scheduled, info.lastEvent)

    }
    
    func testCancelScheduledEmail() async throws {
        let id = try await resend.emails.send(email: .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "send later",
            scheduledAt: .date(Date(timeIntervalSinceNow: 60*60)),
            text: "sending email from XCTest suit with schedule",
        ))
        
        let id2 = try await resend.emails.cancel(emailId: id)
        XCTAssertEqual(id, id2)
        
        let info = try await resend.emails.get(emailId: id)
        XCTAssertEqual(.canceled, info.lastEvent)

    }
    
    func testSendBatch() async throws {
        let response = try await resend.emails.sendBatch(emails: [
            .init(
                from: .init(email: "hadi@example.com", name: "Hadi"),
                to: ["hadi@domain.com"],
                subject: "running xctest",
                text: "sending batch email from XCTest suit"
            ),
            .init(
                from: .init(email: "hadi@example.com", name: "Hadi"),
                to: ["hadi@domain.com"],
                subject: "running xctest 2",
                text: "sending batch email from XCTest suit"
            )
        ])
        XCTAssertEqual(response.count, 2)
    }
    
    func testGetEmail() async throws {
        let from = EmailAddress(email: "hadi@example.com", name: "Hadi")
        let id = try await resend.emails.send(email: .init(
            from: from,
            to: ["hadi@domain.com"],
            subject: "running xctest",
            replyTo: [
                "hadi@example.com",
                "manager@example.com"
            ],
            text: "sending email from XCTest suit",
            headers: [
                .init(name: "X-Entity-Ref-ID", value: "234H3-44"),
                .init(name: "X-Entity-Dep-ID", value: "SALE-03"),
            ]
        ))
        
        let response = try await resend.emails.get(emailId: id)
        
        XCTAssertEqual(response.id, id)
        XCTAssertEqual(response.from.name, from.name)
        XCTAssertEqual(response.from.email, from.email)
        XCTAssertEqual(response.replyTo?.count, 2)        
        
    }
    
    func testRetrieveSentEmailList() async throws {
        
        _ = try await resend.emails.sendBatch(emails: [
        .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "running xctest",
            text: "sending batch email from XCTest suit"
        ),
        .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "running xctest 2",
            text: "sending batch email from XCTest suit"
        )
        ])
        
        print("waiting for 1 second (prevent API rate limit)")
        try await Task.sleep(for: .seconds(1))
        
        let list = try await resend.emails.list(limit: 1)
        XCTAssertGreaterThan(list.data.count, 0)
        
        print("waiting for 1 second (prevent API rate limit)")
        try await Task.sleep(for: .seconds(1))
        
        // we can test `before` and `after` parameters if list has more than 1 item.
        if list.hasMore {
            let email = list.data.first!
            let nextList = try await resend.emails.list(limit: 1, after: email.id)
            let nextEmail = nextList.data.first!
            XCTAssertNotEqual(email.id, nextEmail.id)
            
            print("waiting for 1 second (prevent API rate limit)")
            try await Task.sleep(for: .seconds(1))
            
            let prevList = try await resend.emails.list(limit: 1, before: nextEmail.id)
            let prevEmail = prevList.data.first!
            XCTAssertEqual(prevEmail.id, email.id)
        }
    }
    
    func testGetAttachmentList() async throws {
        let id = try await resend.emails.send(email: .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "running xctest",
            text: "sending batch email from XCTest suit",
            attachments: [
                .init(content: .init(data: .init(contentsOf: .init(filePath: "path/to/a/file"))), filename: "sales.xlsx"),
                .init(content: .init(data: .init(contentsOf: .init(filePath: "path/to/another/file"))), filename: "report.pdf")
            ],
        ))
        let list = try await resend.emails.attachments.list(emailId: id)
        XCTAssertEqual(list.data.count, 2)
        
    }
    
    
    func testGetAttachmentInfo() async throws {
        let id = try await resend.emails.send(email: .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "running xctest",
            text: "sending batch email from XCTest suit",
            attachments: [
                .init(content: .init(data: .init(contentsOf: .init(filePath: "path/to/a/file"))), filename: "sales.xlsx"),
            ],
        ))

        let list = try await resend.emails.attachments.list(emailId: id)
        let attachment = list.data.first!
        let attachmentInfo = try await resend.emails.attachments.get(attachmentId: attachment.id, emailId: id)
        XCTAssertEqual(attachmentInfo.filename, "sales.xlsx")

    }
    
    // Mark: Receiving email tests
    
    func testGetReceivedEmailList() async throws {
        
        _ = try await resend.emails.sendBatch(emails: [
        .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "running xctest",
            text: "sending batch email from XCTest suit"
        ),
        .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "running xctest 2",
            text: "sending batch email from XCTest suit"
        )
        ])
        let list = try await resend.emails.receiving.list()
        
        XCTAssertGreaterThan(list.data.count, 0)
        
    }
    
    func testGetReceivedEmailInfo() async throws {
        _ = try await resend.emails.send(email: .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "running xctest",
            text: "sending batch email from XCTest suit",
            attachments: [
                .init(content: .init(data: .init(contentsOf: .init(filePath: "path/to/a/file"))), filename: "sales.xlsx"),
            ],
        ))
        
        // wait for email to deliver
        print("waiting for 5 seconds for the email to be delivered...")
        try await Task.sleep(for: .seconds(5))

        let list = try await resend.emails.receiving.list()
        let email = list.data.first!
        
        XCTAssertEqual(email.subject, "running xctest")
        XCTAssertEqual(email.text, "sending email from XCTest suit")
        XCTAssertEqual(email.attachments.count, 1)

    }
    
    func testGetReceivedEmailAttachmentList() async throws {
        _ = try await resend.emails.send(email: .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "running xctest",
            text: "sending batch email from XCTest suit",
            attachments: [
                .init(content: .init(data: .init(contentsOf: .init(filePath: "path/to/a/file"))), filename: "sales.xlsx"),
                .init(content: .init(data: .init(contentsOf: .init(filePath: "path/to/another/file"))), filename: "report.pdf"),
            ],
        ))
        
        
        // wait for email to deliver
        print("waiting for 5 seconds for the email to be delivered...")
        try await Task.sleep(for: .seconds(5))

        let list = try await resend.emails.receiving.list()
        let email = list.data.first!
        XCTAssertEqual(email.attachments.count, 2)

        let attachmentList = try await resend.emails.receiving.attachments.list(emailId: email.id)
        XCTAssertEqual(attachmentList.data.count, 2)

    }
    
    
    func testGetReceivedEmailAttachmentInfo() async throws {
        _ = try await resend.emails.send(email: .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
            to: ["hadi@domain.com"],
            subject: "running xctest",
            text: "sending batch email from XCTest suit",
            attachments: [
                .init(content: .init(data: .init(contentsOf: .init(filePath: "path/to/a/file"))), filename: "sales.xlsx"),
            ],
        ))
        
        
        // wait for email to deliver
        print("waiting for 5 seconds for the email to be delivered...")
        try await Task.sleep(for: .seconds(5))

        let list = try await resend.emails.receiving.list()
        let email = list.data.first!
        
        let attachmentList = try await resend.emails.receiving.attachments.list(emailId: email.id)

        // wait for API rate limit
        print("waiting for 1 seconds for API rate limit...")
        try await Task.sleep(for: .seconds(1))

        let firstAttachment = attachmentList.data.first!
        let attachmentInfo = try await resend.emails.receiving.attachments.get(attachmentId: firstAttachment.id, emailId: email.id)
        
        XCTAssertEqual(attachmentInfo.filename, "sales.xlsx")
        XCTAssertGreaterThan(attachmentInfo.size, 0)

    }
    
    
    // Mark: Audience Tests
    func testCreateAudience() async throws {
        let response = try await resend.audiences.create(name: "test-audience")
        XCTAssertEqual(response.name, "test-audience")
    }
    
    func testGetAudience() async throws {
        let response = try await resend.audiences.create(name: "test-audience")
        let id = response.id
        
        let audience = try await resend.audiences.get(audienceId: id)
        
        XCTAssertEqual(audience.id, id)
        XCTAssertEqual(audience.name, "test-audience")
    }
    
    func testDeleteAudience() async throws {
        let response = try await resend.audiences.create(name: "test-audience")
        let id = response.id
        XCTAssertEqual(response.name, "test-audience")

        let audience = try await resend.audiences.delete(audienceId: id)
        XCTAssertEqual(audience.id, id)
        XCTAssertTrue(audience.deleted)
                
        // prevent API rate limit error
        try await Task.sleep(for: .seconds(1))
        
        await XCTAssertThrowsError(try await resend.audiences.get(audienceId: id), "expected throw") { error in
            XCTAssertEqual(error as! ResendError, ResendError.notFound("Audience not found"))
        }
    }
    
    func testGetAudienceList() async throws {
        var response = try await resend.audiences.create(name: "test-audience1")
        let id1 = response.id
        response = try await resend.audiences.create(name: "test-audience2")
        let id2 = response.id
        
        // prevent API rate limit error
        try await Task.sleep(for: .seconds(1))
        
        let list = try await resend.audiences.list()
        
        let ids = list.filter { $0.id == id1 || $0.id == id2 }
        XCTAssertEqual(ids.count, 2)
    }
    
    func testCreateContact() async throws {
        let audience = try await resend.audiences.create(name: "test-audience")
        let contactId = try await resend.contacts.create(audienceId: audience.id,
                                                         email: "hadi@example.com",
                                                         firstName: "Hadi",
                                                         subscriptionStatus: true)

        XCTAssertNotNil(contactId)
    }
    
    func testGetContact() async throws {
        let audience = try await resend.audiences.create(name: "test-audience")
        let contactId = try await resend.contacts.create(audienceId: audience.id,
                                                         email: "hadi@example.com",
                                                         firstName: "Hadi",
                                                         subscriptionStatus: true)
       
        // prevent API rate limit error
        try await Task.sleep(for: .seconds(1))

        let contact = try await resend.contacts.get(audienceId: audience.id,
                                                    contactId: contactId)
        XCTAssertEqual(contact.id, contactId)
        XCTAssertEqual(contact.firstName, "Hadi")
        XCTAssertTrue(contact.subscriptionStatus)
    }
    
    func testUpdateContact() async throws {
        let audience = try await resend.audiences.create(name: "test-audience")
        let contactId = try await resend.contacts.create(audienceId: audience.id,
                                                         email: "hadi@example.com",
                                                         firstName: "Hadi",
                                                         subscriptionStatus: false)
       
        // prevent API rate limit error
        try await Task.sleep(for: .seconds(1))

        _ = try await resend.contacts.update(audienceId: audience.id,
                                             contactId: contactId,
                                             firstName: "John",
                                             subscriptionStatus: true)
        
        let updatedContact = try await resend.contacts.get(audienceId: audience.id, contactId: contactId)
        XCTAssertEqual(updatedContact.id, contactId)
        XCTAssertEqual(updatedContact.firstName, "John")
        XCTAssertTrue(updatedContact.subscriptionStatus)

    }
    
    func testDeleteContactWithId() async throws {
        let audience = try await resend.audiences.create(name: "test-audience")
        let contactId = try await resend.contacts.create(audienceId: audience.id,
                                                         email: "hadi@example.com",
                                                         firstName: "Hadi")

        // prevent API rate limit error
        try await Task.sleep(for: .seconds(1))

        let response = try await resend.contacts.delete(audienceId: audience.id, contactId: contactId)
        XCTAssertEqual(response.contact, contactId)
        XCTAssertTrue(response.deleted)
    }
    
    func testDeleteContactWithEmail() async throws {
        let audience = try await resend.audiences.create(name: "test-audience")
        _ = try await resend.contacts.create(audienceId: audience.id,
                                             email: "hadi@example.com",
                                             firstName: "Hadi")

        // prevent API rate limit error
        try await Task.sleep(for: .seconds(1))

        let response = try await resend.contacts.delete(audienceId: audience.id, email: "hadi@example.com")
        XCTAssertEqual(response.contact, "hadi@example.com")
        XCTAssertTrue(response.deleted)
    }
    
    func testGetContactList() async throws {
        let audience = try await resend.audiences.create(name: "test-audience")
        
        // prevent API rate limit error
        try await Task.sleep(for: .seconds(1))
        
        _ = try await resend.contacts.create(audienceId: audience.id,
                                             email: "hadi@example.com",
                                             firstName: "Hadi",
                                             subscriptionStatus: true)
        _ = try await resend.contacts.create(audienceId: audience.id,
                                             email: "john@example.com",
                                             firstName: "John",
                                             lastName: "Appleseed",
                                             subscriptionStatus: false)
        
        // prevent API rate limit error
        try await Task.sleep(for: .seconds(1))

        let list = try await resend.contacts.list(audienceId: audience.id)
        XCTAssertEqual(list.count, 2)
        XCTAssertNotNil(list.filter { $0.firstName == "Hadi" })
        XCTAssertNotNil(list.filter { $0.firstName == "John" })
        

    }

    // MARK: Segment / Global Contact / Topic Tests
    
    func testCreateSegment() async throws {
        let list = try await resend.segments.list(limit: 100)
        if list.data.count >= 3 {
            XCTAssertGreaterThan(list.data.count, 0)
            return
        }
        let response = try await resend.segments.create(name: "test-segment-\(UUID().uuidString.prefix(8))")
        XCTAssertNotNil(response.id)
    }
    
    func testGetSegment() async throws {
        let list = try await resend.segments.list(limit: 20)
        let segmentId: String
        if let existing = list.data.first {
            segmentId = existing.id
        } else {
            segmentId = try await resend.segments.create(name: "test-segment-get").id
        }
        let segment = try await resend.segments.get(segmentId: segmentId)
        XCTAssertEqual(segment.id, segmentId)
    }
    
    func testDeleteSegment() async throws {
        let list = try await resend.segments.list(limit: 100)
        let segmentId: String
        if list.data.count >= 3, let existing = list.data.first {
            segmentId = existing.id
        } else {
            segmentId = try await resend.segments.create(name: "test-segment-delete").id
        }
        let deleted = try await resend.segments.delete(segmentId: segmentId)
        XCTAssertEqual(deleted.id, segmentId)
        XCTAssertTrue(deleted.deleted)
    }
    
    func testListSegments() async throws {
        let list = try await resend.segments.list(limit: 20)
        XCTAssertNotNil(list.data)
    }
    
    func testCreateGlobalContact() async throws {
        let contactId = try await resend.contacts.create(
            email: "global-contact-\(UUID().uuidString)@example.com",
            firstName: "Hadi",
            unsubscribed: false
        )
        XCTAssertNotNil(contactId)
    }
    
    func testGlobalContactLifecycle() async throws {
        let email = "global-lifecycle-\(UUID().uuidString)@example.com"
        let contactId = try await resend.contacts.create(
            email: email,
            firstName: "Hadi",
            unsubscribed: false
        )
        
        try await Task.sleep(for: .seconds(1))
        
        let contact = try await resend.contacts.get(idOrEmail: contactId)
        XCTAssertEqual(contact.id, contactId)
        XCTAssertEqual(contact.email, email)
        XCTAssertEqual(contact.firstName, "Hadi")
        XCTAssertFalse(contact.unsubscribed)
        
        _ = try await resend.contacts.update(idOrEmail: contactId, firstName: "John", unsubscribed: true)
        let updated = try await resend.contacts.get(idOrEmail: contactId)
        XCTAssertEqual(updated.firstName, "John")
        XCTAssertTrue(updated.unsubscribed)
        
        let deleted = try await resend.contacts.delete(idOrEmail: contactId)
        XCTAssertEqual(deleted.contact, contactId)
        XCTAssertTrue(deleted.deleted)
    }
    
    func testContactSegmentMembership() async throws {
        let list = try await resend.segments.list(limit: 20)
        let segmentId: String
        if let existing = list.data.first {
            segmentId = existing.id
        } else {
            segmentId = try await resend.segments.create(name: "test-membership-segment").id
        }
        let email = "segment-member-\(UUID().uuidString)@example.com"
        let contactId = try await resend.contacts.create(email: email, firstName: "Hadi", unsubscribed: false)
        
        try await Task.sleep(for: .seconds(1))
        
        let added = try await resend.contacts.addToSegment(contactId: contactId, segmentId: segmentId)
        XCTAssertEqual(added.id, contactId)
        XCTAssertEqual(added.audienceId, segmentId)
        
        let segments = try await resend.contacts.listSegments(contactId: contactId)
        XCTAssertTrue(segments.data.contains(where: { $0.id == segmentId }))
        
        let removed = try await resend.contacts.removeFromSegment(contactId: contactId, segmentId: segmentId)
        XCTAssertEqual(removed.id, contactId)
        XCTAssertEqual(removed.audienceId, segmentId)
        XCTAssertEqual(removed.deleted, true)
    }
    
    func testCreateTopicAndAssignToContact() async throws {
        let topic = try await resend.topics.create(
            name: "test-topic-\(UUID().uuidString.prefix(8))",
            defaultSubscription: .optIn,
            description: "Test topic"
        )
        XCTAssertNotNil(topic.id)
        
        let contactId = try await resend.contacts.create(
            email: "topic-contact-\(UUID().uuidString)@example.com",
            firstName: "Hadi",
            unsubscribed: false
        )
        
        try await Task.sleep(for: .seconds(1))
        
        let updated = try await resend.contacts.updateTopics(
            contactId: contactId,
            topics: [.init(id: topic.id, subscription: .optIn)]
        )
        XCTAssertEqual(updated.id, contactId)
        
        let topics = try await resend.contacts.listTopics(contactId: contactId)
        XCTAssertTrue(topics.data.contains(where: { $0.id == topic.id }))
    }
    
    func testListGlobalContacts() async throws {
        let email = "list-contact-\(UUID().uuidString)@example.com"
        _ = try await resend.contacts.create(email: email, firstName: "Hadi", unsubscribed: false)
        try await Task.sleep(for: .seconds(1))
        let list = try await resend.contacts.list(limit: 20)
        XCTAssertGreaterThan(list.data.count, 0)
    }

    // MARK: Helper
    /// Delete all audiences created via tests
    func testDeleteAllAudience() async throws {
        let list = try await resend.audiences.list()

        await list.asyncForEach { audience in
            do {
                _ = try await resend.audiences.delete(audienceId: audience.id)
                try await Task.sleep(for: .milliseconds(600))
            } catch {

            }
        }
    }

    // MARK: API Key Tests
    func testCreateAPIKey() async throws {
        let response = try await resend.apiKeys.create(name: "Test Key", permission: "full_access")
        XCTAssertNotNil(response.id)
        XCTAssertNotNil(response.token)
    }
    
    func testListAPIKeys() async throws {
        let keys = try await resend.apiKeys.list()
        XCTAssertGreaterThan(keys.count, 0)
    }
    
    func testDeleteAPIKey() async throws {
        let keys = try await resend.apiKeys.list()
        guard let key = keys.first else {
            XCTFail("No API keys to delete")
            return
        }
        
        try await resend.apiKeys.delete(apiKeyId: key.id)
    }
    
    // MARK: Domain Tests
    func testCreateDomain() async throws {
        let response = try await resend.domains.create(name: "example.com")
        XCTAssertNotNil(response.id)
        XCTAssertEqual(response.name, "example.com")
    }
    
    func testRetrieveDomain() async throws {
        let domain = try await resend.domains.retrieve(domainId: "d91cd9bd-1176-453e-8fc1-35364d380206")
        XCTAssertEqual(domain.id, "d91cd9bd-1176-453e-8fc1-35364d380206")
    }
    
    func testVerifyDomain() async throws {
        let response = try await resend.domains.verify(domainId: "d91cd9bd-1176-453e-8fc1-35364d380206")
        XCTAssertEqual(response.id, "d91cd9bd-1176-453e-8fc1-35364d380206")
    }
    
    func testUpdateDomain() async throws {
        let domain = try await resend.domains.update(domainId: "d91cd9bd-1176-453e-8fc1-35364d380206", clickTracking: true, openTracking: true)
        XCTAssertEqual(domain.id, "d91cd9bd-1176-453e-8fc1-35364d380206")
    }
    
    func testListDomains() async throws {
        let domains = try await resend.domains.list()
        XCTAssertGreaterThan(domains.count, 0)
    }
    
    func testDeleteDomain() async throws {
        _ = try await resend.domains.delete(domainId: "d91cd9bd-1176-453e-8fc1-35364d380206")
    }
    
    func testDomainClaimDecoding() throws {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let json = """
        {
            "object": "domain_claim",
            "id": "dacf4072-4119-4d88-932f-6c6126d3a9d1",
            "name": "example.com",
            "status": "pending",
            "domain_id": "d91cd9bd-1176-453e-8fc1-35364d380206",
            "region": "us-east-1",
            "record": {
                "type": "TXT",
                "name": "example.com",
                "value": "resend-domain-verification=3f8a1c2d4e5b6a7f8091a2b3c4d5e6f7",
                "ttl": "Auto"
            },
            "blocked_reason": null,
            "failure_reason": null,
            "created_at": "2024-06-16 17:12:02.059593+00",
            "expires_at": "2024-06-23 17:12:02.059593+00"
        }
        """.data(using: .utf8)!
        
        let claim = try decoder.decode(DomainClaim.self, from: json)
        XCTAssertEqual(claim.id, "dacf4072-4119-4d88-932f-6c6126d3a9d1")
        XCTAssertEqual(claim.name, "example.com")
        XCTAssertEqual(claim.status, "pending")
        XCTAssertEqual(claim.domainId, "d91cd9bd-1176-453e-8fc1-35364d380206")
        XCTAssertEqual(claim.record?.type, "TXT")
        XCTAssertNil(claim.blockedReason)
        XCTAssertNotNil(claim.expiresAt)
    }
    
    func testDomainClaimCreateEncoding() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        
        let body = DomainClaimCreate(
            name: "example.com",
            region: "us-east-1",
            customReturnPath: "send",
            openTracking: true,
            clickTracking: false,
            trackingSubdomain: "links"
        )
        let json = String(data: try encoder.encode(body), encoding: .utf8)!
        XCTAssertTrue(json.contains("\"name\":\"example.com\""))
        XCTAssertTrue(json.contains("\"custom_return_path\":\"send\""))
        XCTAssertTrue(json.contains("\"open_tracking\":true"))
        XCTAssertTrue(json.contains("\"click_tracking\":false"))
        XCTAssertTrue(json.contains("\"tracking_subdomain\":\"links\""))
    }

    // MARK: Broadcast Tests
    func testCreateBroadcast() async throws {
        // Create a test audience
        let audience = try await resend.audiences.create(name: "test-broadcast-audience")
        let broadcast = BroadcastCreate(
            audienceId: audience.id,
            from: EmailAddress(email: "tester@example.com", name: "Tester"),
            subject: "Test Broadcast",
            html: "<h1>Hello {{{FIRST_NAME|there}}}</h1>",
            text: "Hello there",
            name: "Test Broadcast"
        )
        let response = try await resend.broadcasts.create(broadcast: broadcast)
        XCTAssertNotNil(response.id)
    }

    func testListBroadcasts() async throws {
        let broadcasts = try await resend.broadcasts.list()
        XCTAssertNotNil(broadcasts)
        // Not asserting count, as it depends on environment
    }

    func testGetBroadcast() async throws {
        // Create a test audience and broadcast
        let audience = try await resend.audiences.create(name: "test-broadcast-audience-get")
        let broadcast = BroadcastCreate(
            audienceId: audience.id,
            from: EmailAddress(email: "tester@example.com", name: "Tester"),
            subject: "Test Broadcast Get",
            html: "<h1>Hello</h1>",
            name: "Test Broadcast Get"
        )
        let createResponse = try await resend.broadcasts.create(broadcast: broadcast)
        let getResponse = try await resend.broadcasts.get(broadcastId: createResponse.id)
        XCTAssertEqual(getResponse.id, createResponse.id)
        XCTAssertEqual(getResponse.audienceId, audience.id)
        XCTAssertEqual(getResponse.subject, "Test Broadcast Get")
    }

    func testUpdateBroadcast() async throws {
        // Create a test audience and broadcast
        let audience = try await resend.audiences.create(name: "test-broadcast-audience-update")
        let broadcast = BroadcastCreate(
            audienceId: audience.id,
            from: EmailAddress(email: "tester@example.com", name: "Tester"),
            subject: "Test Broadcast Update",
            html: "<h1>Before Update</h1>",
            text: "Before Update",
            name: "Test Broadcast Update"
        )
        let createResponse = try await resend.broadcasts.create(broadcast: broadcast)
        let update = BroadcastUpdate(
            id: createResponse.id,
            subject: "Test Broadcast Updated",
            html: "<h1>After Update</h1>"
        )
        let updateResponse = try await resend.broadcasts.update(update: update)
        XCTAssertEqual(updateResponse.id, createResponse.id)
    }

    func testSendBroadcast() async throws {
        // Create a test audience and broadcast
        let audience = try await resend.audiences.create(name: "test-broadcast-audience-send")
        let broadcast = BroadcastCreate(
            audienceId: audience.id,
            from: EmailAddress(email: "tester@example.com", name: "Tester"),
            subject: "Test Broadcast Send",
            html: "<h1>Send Test</h1>",
            name: "Test Broadcast Send"
        )
        let createResponse = try await resend.broadcasts.create(broadcast: broadcast)
        let sendResponse = try await resend.broadcasts.send(broadcastId: createResponse.id)
        XCTAssertEqual(sendResponse.id, createResponse.id)
    }

    func testDeleteBroadcast() async throws {
        // Create a test audience and broadcast
        let audience = try await resend.audiences.create(name: "test-broadcast-audience-delete")
        let broadcast = BroadcastCreate(
            audienceId: audience.id,
            from: EmailAddress(email: "tester@example.com", name: "Tester"),
            subject: "Test Broadcast Delete",
            html: "<h1>Delete Test</h1>",
            name: "Test Broadcast Delete"
        )
        let createResponse = try await resend.broadcasts.create(broadcast: broadcast)
        let deleteResponse = try await resend.broadcasts.delete(broadcastId: createResponse.id)
        XCTAssertEqual(deleteResponse.id, createResponse.id)
    }
    
    // MARK: - EmailSchedule Decoding Tests

    func testEmailScheduleDecodingInBroadcastSummary() throws {

        // Use a decoder configured exactly like ResendClient.decoder so this
        // test would have caught issue #9 (BroadcastSummary using the wrong
        // date format) instead of hiding it behind a local .iso8601 decoder.
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        // --- scheduledAt as an ISO 8601 date string ---
        let dateJSON = """
        {
            "id": "test-id",
            "audience_id": "audience-id",
            "status": "draft",
            "created_at": "2024-01-01T00:00:00.000000Z",
            "scheduled_at": "2024-01-02T00:00:00.000000Z",
            "sent_at": "2024-01-03T00:00:00.000000Z"
        }
        """.data(using: .utf8)!

        let broadcastWithDate = try decoder.decode(BroadcastSummary.self, from: dateJSON)
        XCTAssertEqual(broadcastWithDate.id, "test-id")
        XCTAssertEqual(broadcastWithDate.audienceId, "audience-id")
        XCTAssertEqual(broadcastWithDate.status, "draft")

        if case .date(let date) = broadcastWithDate.scheduledAt {
            let isoFormatter = DateFormatter()
            isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            let expectedDate = isoFormatter.date(from: "2024-01-02T00:00:00.000000Z")!
            XCTAssertEqual(date, expectedDate)
        } else {
            XCTFail("Expected scheduledAt to be .date case")
        }

        // --- scheduledAt as a natural-language string ---
        let stringJSON = """
        {
            "id": "test-id-2",
            "audience_id": "audience-id-2",
            "status": "scheduled",
            "created_at": "2024-01-01T00:00:00.000000Z",
            "scheduled_at": "in 2 hours",
            "sent_at": null
        }
        """.data(using: .utf8)!

        let broadcastWithString = try decoder.decode(BroadcastSummary.self, from: stringJSON)
        XCTAssertEqual(broadcastWithString.id, "test-id-2")
        XCTAssertEqual(broadcastWithString.audienceId, "audience-id-2")
        XCTAssertEqual(broadcastWithString.status, "scheduled")

        if case .string(let scheduleString) = broadcastWithString.scheduledAt {
            XCTAssertEqual(scheduleString, "in 2 hours")
        } else {
            XCTFail("Expected scheduledAt to be .string case")
        }

        // --- scheduledAt absent (null) ---
        let nullJSON = """
        {
            "id": "test-id-3",
            "audience_id": "audience-id-3",
            "status": "sent",
            "created_at": "2024-01-01T00:00:00.000000Z",
            "scheduled_at": null,
            "sent_at": "2024-01-03T00:00:00.000000Z"
        }
        """.data(using: .utf8)!

        let broadcastWithNull = try decoder.decode(BroadcastSummary.self, from: nullJSON)
        XCTAssertEqual(broadcastWithNull.id, "test-id-3")
        XCTAssertEqual(broadcastWithNull.audienceId, "audience-id-3")
        XCTAssertEqual(broadcastWithNull.status, "sent")
        XCTAssertNil(broadcastWithNull.scheduledAt)
    }
    
    func testSendWithIdempotencyKey() async throws {
        let id = try await resend.emails.send(
            email: .init(
                from: .init(email: "hadi@example.com", name: "Hadi"),
                to: ["hadi@domain.com"],
                subject: "idempotency test",
                text: "test with idempotency key"
            ),
            idempotencyKey: "test-key-123"
        )
        XCTAssertNotNil(id)
    }

    func testSendBatchWithIdempotencyKey() async throws {
        let response = try await resend.emails.sendBatch(
            emails: [
                .init(
                    from: .init(email: "hadi@example.com", name: "Hadi"),
                    to: ["hadi@domain.com"],
                    subject: "batch idempotency test",
                    text: "test batch with idempotency key"
                )
            ],
            idempotencyKey: "batch-key-456"
        )
        XCTAssertEqual(response.count, 1)
    }

    func testSendWithInvalidIdempotencyKey() async throws {
        let longKey = String(repeating: "a", count: 300)
        await XCTAssertThrowsError(try await resend.emails.send(
            email: .init(
                from: .init(email: "hadi@example.com", name: "Hadi"),
                to: ["hadi@domain.com"],
                subject: "invalid idempotency key",
                text: "should fail"
            ),
            idempotencyKey: longKey
        )) { error in
            XCTAssertEqual(error as? ResendError, ResendError.invalidIdempotencyKey("The idempotency key must be between 1-256 characters. Retry with a valid key or without supplying an idempotency key."))
        }
    }

    func testSendBatchWithInvalidIdempotencyKey() async throws {
        let longKey = String(repeating: "b", count: 300)
        await XCTAssertThrowsError(try await resend.emails.sendBatch(
            emails: [
                .init(
                    from: .init(email: "hadi@example.com", name: "Hadi"),
                    to: ["hadi@domain.com"],
                    subject: "invalid batch idempotency key",
                    text: "should fail"
                )
            ],
            idempotencyKey: longKey
        )) { error in
            XCTAssertEqual(error as? ResendError, ResendError.invalidIdempotencyKey("The idempotency key must be between 1-256 characters. Retry with a valid key or without supplying an idempotency key."))
        }
    }
    
    // MARK: - Decoding Tests
    
    func testSegmentListDecoding() throws {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let json = """
        {
            "object": "list",
            "has_more": true,
            "data": [
                {
                    "id": "78261eea-8f8b-4381-83c6-79fa7120f1cf",
                    "name": "Registered Users",
                    "created_at": "2024-10-06 22:59:55.977000+00"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let list = try decoder.decode(SegmentListResponse.self, from: json)
        XCTAssertTrue(list.hasMore)
        XCTAssertEqual(list.data.count, 1)
        XCTAssertEqual(list.data[0].id, "78261eea-8f8b-4381-83c6-79fa7120f1cf")
        XCTAssertEqual(list.data[0].name, "Registered Users")
    }
    
    func testContactTopicListDecoding() throws {
        let decoder = JSONDecoder()
        let json = """
        {
            "object": "list",
            "has_more": false,
            "data": [
                {
                    "id": "b6d24b8e-af0b-4c3c-be0c-359bbd97381e",
                    "name": "Weekly Newsletter",
                    "description": "Weekly updates",
                    "subscription": "opt_in"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let list = try decoder.decode(ContactTopicListResponse.self, from: json)
        XCTAssertFalse(list.hasMore)
        XCTAssertEqual(list.data.count, 1)
        XCTAssertEqual(list.data[0].subscription, .optIn)
        XCTAssertEqual(list.data[0].name, "Weekly Newsletter")
    }
    
    func testAutomationStepEncodingAndDecoding() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let steps: [AutomationStep] = [
            .trigger(key: "start", eventName: "user.created"),
            .delay(key: "wait", duration: "1 hour"),
            .sendEmail(key: "welcome", templateId: "34a080c9-b17d-4187-ad80-5af20266e535"),
            .addToSegment(key: "segment", segmentId: "78261eea-8f8b-4381-83c6-79fa7120f1cf")
        ]
        
        let data = try encoder.encode(steps)
        let decoded = try decoder.decode([AutomationStep].self, from: data)
        
        XCTAssertEqual(decoded.count, 4)
        XCTAssertEqual(decoded[0].key, "start")
        XCTAssertEqual(decoded[0].type, .trigger)
        if case .trigger(let eventName) = decoded[0].config {
            XCTAssertEqual(eventName, "user.created")
        } else {
            XCTFail("Expected trigger config")
        }
        
        if case .delay(let duration) = decoded[1].config {
            XCTAssertEqual(duration, "1 hour")
        } else {
            XCTFail("Expected delay config")
        }
        
        if case .sendEmail(let template, _, _, _) = decoded[2].config {
            XCTAssertEqual(template.id, "34a080c9-b17d-4187-ad80-5af20266e535")
        } else {
            XCTFail("Expected sendEmail config")
        }
        
        if case .addToSegment(let segmentId) = decoded[3].config {
            XCTAssertEqual(segmentId, "78261eea-8f8b-4381-83c6-79fa7120f1cf")
        } else {
            XCTFail("Expected addToSegment config")
        }
    }
    
    func testContactSegmentResponseDecoding() throws {
        let camelJSON = """
        {
            "id": "e169aa45-1ecf-4183-9955-b1499d5701d3",
            "audienceId": "78261eea-8f8b-4381-83c6-79fa7120f1cf"
        }
        """.data(using: .utf8)!
        
        let camel = try JSONDecoder().decode(ContactSegmentResponse.self, from: camelJSON)
        XCTAssertEqual(camel.id, "e169aa45-1ecf-4183-9955-b1499d5701d3")
        XCTAssertEqual(camel.audienceId, "78261eea-8f8b-4381-83c6-79fa7120f1cf")
        XCTAssertEqual(camel.segmentId, "78261eea-8f8b-4381-83c6-79fa7120f1cf")
        
        let snakeJSON = """
        {
            "contact_id": "e169aa45-1ecf-4183-9955-b1499d5701d3",
            "segment_id": "78261eea-8f8b-4381-83c6-79fa7120f1cf",
            "deleted": true
        }
        """.data(using: .utf8)!
        
        let snake = try JSONDecoder().decode(ContactSegmentResponse.self, from: snakeJSON)
        XCTAssertEqual(snake.id, "e169aa45-1ecf-4183-9955-b1499d5701d3")
        XCTAssertEqual(snake.segmentId, "78261eea-8f8b-4381-83c6-79fa7120f1cf")
        XCTAssertEqual(snake.deleted, true)
    }
    
    func testEventSchemaDecoding() throws {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let json = """
        {
            "object": "event",
            "id": "c9b16d4f-ba6c-4e2e-b044-6bf4404e57fd",
            "name": "user.created",
            "schema": {
                "plan": "string",
                "trial": "boolean"
            },
            "created_at": "2024-10-01 12:00:00.000000+00",
            "updated_at": null
        }
        """.data(using: .utf8)!
        
        let event = try decoder.decode(Event.self, from: json)
        XCTAssertEqual(event.name, "user.created")
        XCTAssertEqual(event.schema?["plan"], .string)
        XCTAssertEqual(event.schema?["trial"], .boolean)
    }
    
    func testTemplateListAndDetailDecoding() throws {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let listJSON = """
        {
            "object": "list",
            "has_more": false,
            "data": [
                {
                    "id": "e169aa45-1ecf-4183-9955-b1499d5701d3",
                    "name": "reset-password",
                    "status": "draft",
                    "published_at": null,
                    "created_at": "2024-10-06 23:47:56.678000+00",
                    "updated_at": "2024-10-06 23:47:56.678000+00",
                    "alias": "reset-password"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let list = try decoder.decode(TemplateListResponse.self, from: listJSON)
        XCTAssertFalse(list.hasMore)
        XCTAssertEqual(list.data.count, 1)
        XCTAssertEqual(list.data[0].id, "e169aa45-1ecf-4183-9955-b1499d5701d3")
        XCTAssertEqual(list.data[0].status, .draft)
        XCTAssertNil(list.data[0].publishedAt)
        XCTAssertEqual(list.data[0].alias, "reset-password")
        
        let detailJSON = """
        {
            "object": "template",
            "id": "34a080c9-b17d-4187-ad80-5af20266e535",
            "current_version_id": "b2693018-7abb-4b4b-b4cb-aadf72dc06bd",
            "alias": "order-confirmation",
            "name": "order-confirmation",
            "created_at": "2024-10-06 23:47:56.678000+00",
            "updated_at": "2024-10-06 23:47:56.678000+00",
            "status": "published",
            "published_at": "2024-10-06 23:47:56.678000+00",
            "from": "John Doe <john.doe@example.com>",
            "subject": "Hello, world!",
            "reply_to": null,
            "html": "<p>Name: {{{PRODUCT}}}</p><p>Total: {{{PRICE}}}</p>",
            "text": "Hello, world!",
            "variables": [
                {
                    "id": "e169aa45-1ecf-4183-9955-b1499d5701d3",
                    "key": "PRODUCT",
                    "type": "string",
                    "fallback_value": "item",
                    "created_at": "2024-10-06 23:47:56.678000+00",
                    "updated_at": "2024-10-06 23:47:56.678000+00"
                },
                {
                    "id": "a169aa45-1ecf-4183-9955-b1499d5701d4",
                    "key": "PRICE",
                    "type": "number",
                    "fallback_value": 25,
                    "created_at": "2024-10-06 23:47:56.678000+00",
                    "updated_at": "2024-10-06 23:47:56.678000+00"
                }
            ],
            "has_unpublished_versions": false
        }
        """.data(using: .utf8)!
        
        let template = try decoder.decode(Template.self, from: detailJSON)
        XCTAssertEqual(template.id, "34a080c9-b17d-4187-ad80-5af20266e535")
        XCTAssertEqual(template.status, .published)
        XCTAssertNotNil(template.publishedAt)
        XCTAssertEqual(template.variables?.count, 2)
        XCTAssertEqual(template.variables?[0].fallbackValue, .string("item"))
        XCTAssertEqual(template.variables?[1].fallbackValue, .number(25))
        XCTAssertEqual(template.hasUnpublishedVersions, false)
    }
    
    func testTemplateVariableAndEmailTemplateEncoding() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        
        let variables: [TemplateVariableInput] = [
            .string("PRODUCT", fallback: "item"),
            .number("PRICE", fallback: 25)
        ]
        let variablesJSON = String(data: try encoder.encode(variables), encoding: .utf8)!
        XCTAssertTrue(variablesJSON.contains("\"fallback_value\":\"item\""))
        XCTAssertTrue(variablesJSON.contains("\"fallback_value\":25"))
        XCTAssertTrue(variablesJSON.contains("\"type\":\"string\""))
        XCTAssertTrue(variablesJSON.contains("\"type\":\"number\""))
        
        let email = ResendEmail(
            from: "App <onboarding@resend.dev>",
            to: ["user@example.com"],
            subject: "Order confirmation",
            template: EmailTemplate(
                id: "order-confirmation",
                variables: [
                    "PRODUCT": .string("Widget"),
                    "PRICE": .number(19.99)
                ]
            )
        )
        let emailJSON = String(data: try encoder.encode(email), encoding: .utf8)!
        XCTAssertTrue(emailJSON.contains("\"template\":{"))
        XCTAssertTrue(emailJSON.contains("\"id\":\"order-confirmation\""))
        XCTAssertFalse(emailJSON.contains("\"html\""))
        XCTAssertFalse(emailJSON.contains("\"text\""))
    }
    
    // MARK: - Event / Automation Tests
    
    func testCreateAndListEvents() async throws {
        let name = "test.event.\(UUID().uuidString.prefix(8))"
        let created = try await resend.events.create(
            name: name,
            schema: ["plan": .string]
        )
        XCTAssertNotNil(created.id)
        
        try await Task.sleep(for: .seconds(1))
        
        let event = try await resend.events.get(identifier: created.id)
        XCTAssertEqual(event.id, created.id)
        XCTAssertEqual(event.name, name)
        
        let list = try await resend.events.list(limit: 20)
        XCTAssertTrue(list.data.contains(where: { $0.id == created.id }))
        
        let deleted = try await resend.events.delete(identifier: created.id)
        XCTAssertEqual(deleted.id, created.id)
        XCTAssertTrue(deleted.deleted)
    }
    
    func testCreateAutomation() async throws {
        let eventName = "automation.trigger.\(UUID().uuidString.prefix(8))"
        _ = try await resend.events.create(name: eventName)
        
        try await Task.sleep(for: .seconds(1))
        
        let created = try await resend.automations.create(
            name: "test-automation-\(UUID().uuidString.prefix(8))",
            status: .disabled,
            steps: [
                .trigger(key: "start", eventName: eventName),
                .delay(key: "wait", duration: "1 minute"),
                .contactUpdate(key: "update", firstName: "Auto")
            ],
            connections: [
                .init(from: "start", to: "wait"),
                .init(from: "wait", to: "update")
            ]
        )
        XCTAssertNotNil(created.id)
        
        let automation = try await resend.automations.get(automationId: created.id)
        XCTAssertEqual(automation.id, created.id)
        XCTAssertEqual(automation.status, .disabled)
        
        let list = try await resend.automations.list(limit: 20)
        XCTAssertTrue(list.data.contains(where: { $0.id == created.id }))
        
        let stopped = try await resend.automations.stop(automationId: created.id)
        XCTAssertEqual(stopped.id, created.id)
        
        let deleted = try await resend.automations.delete(automationId: created.id)
        XCTAssertEqual(deleted.id, created.id)
        XCTAssertTrue(deleted.deleted)
    }
    
    func testSendEvent() async throws {
        let eventName = "send.event.\(UUID().uuidString.prefix(8))"
        _ = try await resend.events.create(name: eventName)
        
        try await Task.sleep(for: .seconds(1))
        
        let response = try await resend.events.send(
            event: eventName,
            email: "hadi@example.com",
            payload: ["plan": "pro"]
        )
        XCTAssertEqual(response.event, eventName)
    }
    
    // MARK: - Template Tests
    
    func testTemplateLifecycle() async throws {
        let suffix = UUID().uuidString.prefix(8)
        let name = "test-template-\(suffix)"
        let alias = "test-alias-\(suffix)"
        
        let created = try await resend.templates.create(
            name: name,
            html: "<p>Name: {{{PRODUCT}}}</p><p>Total: {{{PRICE}}}</p>",
            alias: alias,
            from: .init(email: "onboarding@resend.dev", name: "App"),
            subject: "Order confirmation",
            variables: [
                .string("PRODUCT", fallback: "item"),
                .number("PRICE", fallback: 25)
            ]
        )
        XCTAssertNotNil(created.id)
        
        try await Task.sleep(for: .seconds(1))
        
        let template = try await resend.templates.get(idOrAlias: created.id)
        XCTAssertEqual(template.id, created.id)
        XCTAssertEqual(template.name, name)
        XCTAssertEqual(template.alias, alias)
        XCTAssertEqual(template.status, .draft)
        
        let updated = try await resend.templates.update(
            idOrAlias: created.id,
            html: "<p>Hello {{{PRODUCT}}}</p>"
        )
        XCTAssertEqual(updated.id, created.id)
        
        let list = try await resend.templates.list(limit: 20)
        XCTAssertTrue(list.data.contains(where: { $0.id == created.id }))
        
        let published = try await resend.templates.publish(idOrAlias: created.id)
        XCTAssertEqual(published.id, created.id)
        
        let publishedTemplate = try await resend.templates.get(idOrAlias: alias)
        XCTAssertEqual(publishedTemplate.status, .published)
        XCTAssertNotNil(publishedTemplate.publishedAt)
        
        let duplicated = try await resend.templates.duplicate(idOrAlias: created.id)
        XCTAssertNotNil(duplicated.id)
        XCTAssertNotEqual(duplicated.id, created.id)
        
        let deletedDuplicate = try await resend.templates.delete(idOrAlias: duplicated.id)
        XCTAssertEqual(deletedDuplicate.id, duplicated.id)
        XCTAssertTrue(deletedDuplicate.deleted)
        
        let deleted = try await resend.templates.delete(idOrAlias: created.id)
        XCTAssertEqual(deleted.id, created.id)
        XCTAssertTrue(deleted.deleted)
    }
    
    // MARK: - Webhook Tests
    
    func testWebhookListDecoding() throws {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let listJSON = """
        {
            "object": "list",
            "has_more": false,
            "data": [
                {
                    "id": "7ab123cd-ef45-6789-abcd-ef0123456789",
                    "created_at": "2024-09-10 10:15:30.000000+00",
                    "status": "disabled",
                    "endpoint": "https://first-webhook.example.com/handler",
                    "events": ["email.sent"]
                },
                {
                    "id": "4dd369bc-aa82-4ff3-97de-514ae3000ee0",
                    "created_at": "2024-08-22 15:28:00.000000+00",
                    "status": "enabled",
                    "endpoint": "https://second-webhook.example.com/receive",
                    "events": ["email.received", "email.delivered"]
                }
            ]
        }
        """.data(using: .utf8)!
        
        let list = try decoder.decode(WebhookListResponse.self, from: listJSON)
        XCTAssertFalse(list.hasMore)
        XCTAssertEqual(list.data.count, 2)
        XCTAssertEqual(list.data[0].status, .disabled)
        XCTAssertEqual(list.data[0].events, [.emailSent])
        XCTAssertEqual(list.data[1].status, .enabled)
        XCTAssertEqual(list.data[1].events, [.emailReceived, .emailDelivered])
        
        let detailJSON = """
        {
            "object": "webhook",
            "id": "4dd369bc-aa82-4ff3-97de-514ae3000ee0",
            "created_at": "2024-08-22 15:28:00.000000+00",
            "status": "enabled",
            "endpoint": "https://example.com/handler",
            "events": ["email.sent", "contact.created"],
            "signing_secret": "whsec_xxxxxxxxxx"
        }
        """.data(using: .utf8)!
        
        let webhook = try decoder.decode(Webhook.self, from: detailJSON)
        XCTAssertEqual(webhook.id, "4dd369bc-aa82-4ff3-97de-514ae3000ee0")
        XCTAssertEqual(webhook.endpoint, "https://example.com/handler")
        XCTAssertEqual(webhook.events, [.emailSent, .contactCreated])
        XCTAssertEqual(webhook.signingSecret, "whsec_xxxxxxxxxx")
    }
    
    func testWebhookCreateEncoding() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        
        let body = WebhookCreate(
            endpoint: "https://example.com/handler",
            events: [.emailSent, .emailDelivered]
        )
        let json = String(data: try encoder.encode(body), encoding: .utf8)!
        XCTAssertTrue(json.contains("example.com"))
        XCTAssertTrue(json.contains("\"email.sent\""))
        XCTAssertTrue(json.contains("\"email.delivered\""))
    }
    
    func testWebhookLifecycle() async throws {
        let endpoint = "https://example.com/webhook-\(UUID().uuidString.prefix(8))"
        
        let created = try await resend.webhooks.create(
            endpoint: endpoint,
            events: [.emailSent]
        )
        XCTAssertNotNil(created.id)
        XCTAssertFalse(created.signingSecret.isEmpty)
        
        try await Task.sleep(for: .seconds(1))
        
        let webhook = try await resend.webhooks.get(webhookId: created.id)
        XCTAssertEqual(webhook.id, created.id)
        XCTAssertEqual(webhook.endpoint, endpoint)
        XCTAssertEqual(webhook.events, [.emailSent])
        
        let updated = try await resend.webhooks.update(
            webhookId: created.id,
            endpoint: "\(endpoint)/updated",
            events: [.emailSent, .emailDelivered],
            status: .disabled
        )
        XCTAssertEqual(updated.id, created.id)
        
        let list = try await resend.webhooks.list(limit: 20)
        XCTAssertTrue(list.data.contains(where: { $0.id == created.id }))
        
        let deleted = try await resend.webhooks.delete(webhookId: created.id)
        XCTAssertEqual(deleted.id, created.id)
        XCTAssertTrue(deleted.deleted)
    }
    
    // MARK: - Suppression Tests
    
    func testSuppressionListDecoding() throws {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let listJSON = """
        {
            "object": "list",
            "has_more": false,
            "data": [
                {
                    "object": "suppression",
                    "id": "e169aa45-1ecf-4183-9955-b1499d5701d3",
                    "email": "steve.wozniak@example.com",
                    "origin": "manual",
                    "source_id": null,
                    "created_at": "2024-10-06 23:47:56.678000+00"
                },
                {
                    "object": "suppression",
                    "id": "520784e2-887d-4c25-b53c-4ad46ad38100",
                    "email": "susan.kare@example.com",
                    "origin": "bounce",
                    "source_id": "4ef9a417-02e9-4d39-ad75-9611e0fcc33c",
                    "created_at": "2024-10-07 08:12:03.412000+00"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let list = try decoder.decode(SuppressionListResponse.self, from: listJSON)
        XCTAssertFalse(list.hasMore)
        XCTAssertEqual(list.data.count, 2)
        XCTAssertEqual(list.data[0].origin, .manual)
        XCTAssertNil(list.data[0].sourceId)
        XCTAssertEqual(list.data[1].origin, .bounce)
        XCTAssertEqual(list.data[1].sourceId, "4ef9a417-02e9-4d39-ad75-9611e0fcc33c")
    }
    
    func testSuppressionBatchEncoding() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        
        let addJSON = String(data: try encoder.encode(SuppressionBatchAdd(emails: ["a@example.com", "b@example.com"])), encoding: .utf8)!
        XCTAssertTrue(addJSON.contains("\"emails\""))
        XCTAssertTrue(addJSON.contains("a@example.com"))
        
        let removeByEmail = String(data: try encoder.encode(SuppressionBatchRemove(emails: ["a@example.com"])), encoding: .utf8)!
        XCTAssertTrue(removeByEmail.contains("\"emails\""))
        XCTAssertFalse(removeByEmail.contains("\"ids\""))
        
        let removeById = String(data: try encoder.encode(SuppressionBatchRemove(ids: ["e169aa45-1ecf-4183-9955-b1499d5701d3"])), encoding: .utf8)!
        XCTAssertTrue(removeById.contains("\"ids\""))
        XCTAssertFalse(removeById.contains("\"emails\""))
    }
    
    func testSuppressionLifecycle() async throws {
        let email = "suppress-\(UUID().uuidString.prefix(8))@example.com"
        
        let added = try await resend.suppressions.add(email: email)
        XCTAssertNotNil(added.id)
        
        try await Task.sleep(for: .seconds(1))
        
        let suppression = try await resend.suppressions.get(idOrEmail: email)
        XCTAssertEqual(suppression.id, added.id)
        XCTAssertEqual(suppression.email.lowercased(), email.lowercased())
        XCTAssertEqual(suppression.origin, .manual)
        
        let list = try await resend.suppressions.list(origin: .manual, limit: 20)
        XCTAssertTrue(list.data.contains(where: { $0.id == added.id }))
        
        let removed = try await resend.suppressions.remove(idOrEmail: added.id)
        XCTAssertEqual(removed.id, added.id)
        XCTAssertTrue(removed.deleted)
    }
    
    func testSuppressionBatchLifecycle() async throws {
        let email1 = "batch-suppress-1-\(UUID().uuidString.prefix(8))@example.com"
        let email2 = "batch-suppress-2-\(UUID().uuidString.prefix(8))@example.com"
        
        let added = try await resend.suppressions.batchAdd(emails: [email1, email2])
        XCTAssertEqual(added.data.count, 2)
        
        try await Task.sleep(for: .seconds(1))
        
        let removed = try await resend.suppressions.batchRemove(emails: [email1, email2])
        XCTAssertEqual(removed.data.count, 2)
        XCTAssertTrue(removed.data.allSatisfy { $0.deleted })
    }
    
    // MARK: - Contact Property Tests
    
    func testContactPropertyListDecoding() throws {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let listJSON = """
        {
            "object": "list",
            "has_more": false,
            "data": [
                {
                    "id": "b6d24b8e-af0b-4c3c-be0c-359bbd97381e",
                    "key": "company_name",
                    "type": "string",
                    "fallback_value": "Acme Corp",
                    "created_at": "2024-04-08 00:11:13.110779+00"
                },
                {
                    "id": "a6d24b8e-af0b-4c3c-be0c-359bbd97381f",
                    "key": "employee_count",
                    "type": "number",
                    "fallback_value": 10,
                    "created_at": "2024-04-08 00:11:13.110779+00"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let list = try decoder.decode(ContactPropertyListResponse.self, from: listJSON)
        XCTAssertFalse(list.hasMore)
        XCTAssertEqual(list.data.count, 2)
        XCTAssertEqual(list.data[0].key, "company_name")
        XCTAssertEqual(list.data[0].type, .string)
        XCTAssertEqual(list.data[0].fallbackValue, .string("Acme Corp"))
        XCTAssertEqual(list.data[1].type, .number)
        XCTAssertEqual(list.data[1].fallbackValue, .number(10))
    }
    
    func testContactPropertyCreateEncoding() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        
        let body = ContactPropertyCreate(
            key: "company_name",
            type: .string,
            fallbackValue: .string("Acme Corp")
        )
        let json = String(data: try encoder.encode(body), encoding: .utf8)!
        XCTAssertTrue(json.contains("\"fallback_value\":\"Acme Corp\""))
        XCTAssertTrue(json.contains("\"key\":\"company_name\""))
        XCTAssertTrue(json.contains("\"type\":\"string\""))
    }
    
    func testContactPropertyLifecycle() async throws {
        let key = "company_\(UUID().uuidString.prefix(8))"
        
        let created = try await resend.contactProperties.create(
            key: key,
            type: .string,
            fallbackValue: .string("Acme Corp")
        )
        XCTAssertNotNil(created.id)
        
        try await Task.sleep(for: .seconds(1))
        
        let property = try await resend.contactProperties.get(propertyId: created.id)
        XCTAssertEqual(property.id, created.id)
        XCTAssertEqual(property.key, key)
        XCTAssertEqual(property.type, .string)
        XCTAssertEqual(property.fallbackValue, .string("Acme Corp"))
        
        let updated = try await resend.contactProperties.update(
            propertyId: created.id,
            fallbackValue: .string("Example Company")
        )
        XCTAssertEqual(updated.id, created.id)
        
        let list = try await resend.contactProperties.list(limit: 20)
        XCTAssertTrue(list.data.contains(where: { $0.id == created.id }))
        
        let deleted = try await resend.contactProperties.delete(propertyId: created.id)
        XCTAssertEqual(deleted.id, created.id)
        XCTAssertTrue(deleted.deleted)
    }
    
    // MARK: - Log Tests
    
    func testLogListAndDetailDecoding() throws {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let listJSON = """
        {
            "object": "list",
            "has_more": true,
            "data": [
                {
                    "id": "37e4414c-5e25-4dbc-a071-43552a4bd53b",
                    "created_at": "2024-03-30 13:43:54.622865+00",
                    "endpoint": "/emails",
                    "method": "POST",
                    "response_status": 200,
                    "user_agent": "resend-node:6.0.3"
                },
                {
                    "id": "a1b2c3d4-5e6f-7a8b-9c0d-1e2f3a4b5c6d",
                    "created_at": "2024-03-30 12:15:00.123456+00",
                    "endpoint": "/emails/4ef9a417-02e9-4d39-ad75-9611e0fcc33c",
                    "method": "GET",
                    "response_status": 200,
                    "user_agent": null
                }
            ]
        }
        """.data(using: .utf8)!
        
        let list = try decoder.decode(LogListResponse.self, from: listJSON)
        XCTAssertTrue(list.hasMore)
        XCTAssertEqual(list.data.count, 2)
        XCTAssertEqual(list.data[0].method, .post)
        XCTAssertEqual(list.data[0].responseStatus, 200)
        XCTAssertNil(list.data[1].userAgent)
        
        let detailJSON = """
        {
            "object": "log",
            "id": "37e4414c-5e25-4dbc-a071-43552a4bd53b",
            "created_at": "2024-03-30 13:43:54.622865+00",
            "endpoint": "/emails",
            "method": "POST",
            "response_status": 200,
            "user_agent": "resend-node:6.0.3",
            "request_body": {
                "from": "Acme <onboarding@resend.dev>",
                "to": ["delivered@resend.dev"],
                "subject": "Hello World"
            },
            "response_body": {
                "id": "4ef9a417-02e9-4d39-ad75-9611e0fcc33c"
            }
        }
        """.data(using: .utf8)!
        
        let log = try decoder.decode(Log.self, from: detailJSON)
        XCTAssertEqual(log.id, "37e4414c-5e25-4dbc-a071-43552a4bd53b")
        XCTAssertEqual(log.method, .post)
        if case .string(let from) = log.requestBody?["from"] {
            XCTAssertEqual(from, "Acme <onboarding@resend.dev>")
        } else {
            XCTFail("Expected request_body.from string")
        }
        if case .array(let to) = log.requestBody?["to"],
           case .string(let first) = to.first {
            XCTAssertEqual(first, "delivered@resend.dev")
        } else {
            XCTFail("Expected request_body.to array")
        }
        if case .string(let id) = log.responseBody?["id"] {
            XCTAssertEqual(id, "4ef9a417-02e9-4d39-ad75-9611e0fcc33c")
        } else {
            XCTFail("Expected response_body.id string")
        }
    }
    
    func testListLogs() async throws {
        let list = try await resend.logs.list(limit: 5)
        XCTAssertGreaterThanOrEqual(list.data.count, 0)
        
        if let first = list.data.first {
            let log = try await resend.logs.get(logId: first.id)
            XCTAssertEqual(log.id, first.id)
            XCTAssertEqual(log.endpoint, first.endpoint)
            XCTAssertEqual(log.method, first.method)
        }
    }

}
