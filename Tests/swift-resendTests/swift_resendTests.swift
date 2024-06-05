import XCTest
import AsyncHTTPClient
@testable import swift_resend

final class swift_resendTests: XCTestCase {
    func testSend() async throws {
        let resend = ResendClient(httpClient: HTTPClient.shared, apiKey: "")
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
                .init(content: .init(data: .init(contentsOf: .init(filePath: "/Users/hadi/temp/db2.sqlite"))), filename: "db.sqlite")
            ],
            tags: [
                .init(name: "priority", value: "medium"),
                .init(name: "department", value: "sales")
            ]
        ))
        XCTAssertNotNil(response.id)
    }
}
