import XCTest
import AsyncHTTPClient
@testable import swift_resend

final class swift_resendTests: XCTestCase {
    func testSend() async throws {
        let resend = ResendClient(httpClient: HTTPClient.shared, apiKey: "")
        let response = try await resend.send(email: .init(from: "hadi@email.com"))
        XCTAssertNotNil(response.id)
    }
}
