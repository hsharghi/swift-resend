import Foundation

public struct EmailCanceledResponse: Codable {
    public let id: String

    init(id: String) {
        self.id = id
    }
}
