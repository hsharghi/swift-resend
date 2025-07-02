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
        let id = try await resend.emails.send(email: .init(
            from: .init(email: "hadi@example.com", name: "Hadi"),
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
            ],
            attachments: [
                .init(content: .init(data: .init(contentsOf: .init(filePath: "path/to/a/file"))), filename: "sales.xlsx")
            ],
            tags: [
                .init(name: "priority", value: "medium"),
                .init(name: "department", value: "sales")
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
        XCTAssertEqual("scheduled", info.lastEvent)
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
        XCTAssertEqual("scheduled", info.lastEvent)
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
        XCTAssertEqual("scheduled", info.lastEvent)

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
        XCTAssertEqual("canceled", info.lastEvent)

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
        try await resend.domains.delete(domainId: "d91cd9bd-1176-453e-8fc1-35364d380206")
    }

    // MARK: Broadcast Tests
    func testCreateBroadcast() async throws {
        // Create a test audience
        let audience = try await resend.audiences.create(name: "test-broadcast-audience")
        let broadcast = BroadcastCreate(
            audienceId: audience.id,
            from: "Tester <tester@example.com>",
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
            from: "Tester <tester@example.com>",
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
            from: "Tester <tester@example.com>",
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
            from: "Tester <tester@example.com>",
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
            from: "Tester <tester@example.com>",
            subject: "Test Broadcast Delete",
            html: "<h1>Delete Test</h1>",
            name: "Test Broadcast Delete"
        )
        let createResponse = try await resend.broadcasts.create(broadcast: broadcast)
        let deleteResponse = try await resend.broadcasts.delete(broadcastId: createResponse.id)
        XCTAssertEqual(deleteResponse.id, createResponse.id)
    }

}
