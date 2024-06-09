import XCTest
import AsyncHTTPClient
@testable import swift_resend

final class swift_resendTests: XCTestCase {
    
    func testSend() async throws {
        let resend = ResendClient(httpClient: HTTPClient.shared, apiKey: "RESEND_API_KEY")
        let response = try await resend.emails.send(email: .init(
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
        XCTAssertNotNil(response.id)
    }
    
    func testSendBatch() async throws {
        let resend = ResendClient(httpClient: HTTPClient.shared, apiKey: "RESEND_API_KEY")
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
        let resend = ResendClient(httpClient: HTTPClient.shared, apiKey: "RESEND_API_KEY")
        let from = EmailAddress(email: "hadi@example.com", name: "Hadi")
        let sentResponse = try await resend.emails.send(email: .init(
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
        
        let id = sentResponse.id

        let response = try await resend.emails.get(emailId: id)
        
        XCTAssertEqual(response.id, id)
        XCTAssertEqual(response.from.name, from.name)
        XCTAssertEqual(response.from.email, from.email)
        XCTAssertEqual(response.replyTo?.count, 2)
        XCTAssertEqual(response.replyTo?.count, 2)
        
        
    }
}
