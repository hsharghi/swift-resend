import XCTest
import AsyncHTTPClient
@testable import swift_resend

final class swift_resendTestsPrivate: XCTestCase {

    private var httpClient: HTTPClient!
    private var resend: ResendClient!
    
    override func setUp() {
        httpClient = HTTPClient(eventLoopGroupProvider: .singleton)
        
        resend = ResendClient(httpClient: httpClient, apiKey: "re_8qw6saZF_MTKD8kcwNKHxNtaygMj8ckX8")
    }
    
    override func tearDown() async throws {
        try await httpClient.shutdown()
    }
        
    func testSend() async throws {
        let response = try await resend.emails.send(email: .init(
            from: .init(email: "hadi@softworks.ir", name: "Hadi"),
            to: ["hsharghi@gmail.com"],
            subject: "running xctest",
            replyTo: [
                "hsharghi@gmail.com",
                "hsharghi@icloud.com"
            ],
            text: "sending email from XCTest suit",
            headers: [
                .init(name: "X-Entity-Ref-ID", value: "234H3-44"),
                .init(name: "X-Entity-Dep-ID", value: "SALE-03"),
            ],
            attachments: [
                .init(filePath: "/Users/hadi/Downloads/statement.pdf"),
                .init(content: .init(data: .init(contentsOf: .init(filePath: "/Users/hadi/Downloads/statement.pdf"))), filename: "db.sqlite")
            ],
            tags: [
                .init(name: "priority", value: "medium"),
                .init(name: "department", value: "sales")
            ]
        ))
        XCTAssertNotNil(response.id)
    }
    
    func testSendBatch() async throws {
        let response = try await resend.emails.sendBatch(emails: [
        .init(
            from: .init(email: "hadi@softworks.ir", name: "Hadi"),
            to: ["hsharghi@gmail.com"],
            subject: "running xctest",
            text: "sending batch email from XCTest suit"
        ),
        .init(
            from: .init(email: "hadi@softworks.ir", name: "Hadi"),
            to: ["hsharghi@icloud.com"],
            subject: "running xctest 2",
            text: "sending batch email from XCTest suit"
        )
        ])
        XCTAssertEqual(response.count, 2)
    }
    
    func testGetEmail() async throws {
//        let sentResponse = try await resend.emails.send(email: .init(
//            from: .init(email: "hadi@softworks.ir", name: "Hadi"),
//            to: ["hsharghi@gmail.com"],
//            subject: "running xctest",
//            replyTo: [
//                "hsharghi@gmail.com",
//                "hsharghi@icloud.com"
//            ],
//            text: "sending email from XCTest suit",
//            headers: [
//                .init(name: "X-Entity-Ref-ID", value: "234H3-44"),
//                .init(name: "X-Entity-Dep-ID", value: "SALE-03"),
//            ],
//            attachments: [
//                .init(content: .init(data: .init(contentsOf: .init(filePath: "/Users/hadi/temp/db2.sqlite"))), filename: "db.sqlite")
//            ],
//            tags: [
//                .init(name: "priority", value: "medium"),
//                .init(name: "department", value: "sales")
//            ]
//        ))
//
//        let id = sentResponse.id
//
//        let response = try await resend.emails.get(emailId: sentResponse.id)
        let response = try await resend.emails.get(emailId: "77fd6234-8500-496b-bcea-944f64930b83")
        let id = "77fd6234-8500-496b-bcea-944f64930b83"
        
        
        XCTAssertEqual(response.id, id)
        XCTAssertEqual(response.from.name, "Hadi")
        XCTAssertEqual(response.from.email, "hadi@softworks.ir")
        XCTAssertEqual(response.replyTo?.count, 2)
        
    }
    
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
}
