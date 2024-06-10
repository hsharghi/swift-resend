import Foundation

public struct EmailAddress: Decodable {
    /// format: email
    public var email: String
    
    /// The name of the person to whom you are sending an email.
    public var name: String?
    
    public init(email: String, name: String? = nil) {
        self.email = email
        self.name = name
    }
    
    var string: String {
        guard let name = self.name else {
            return self.email
        }
        return "\(name) <\(self.email)>"
    }
    
}

extension EmailAddress: ExpressibleByStringLiteral {
    public init(stringLiteral email: StringLiteralType) {
        self.init(email: email)
    }
}

extension Array where Element == EmailAddress {
    var stringArray: [String] {
        map { $0.string }
    }
}
