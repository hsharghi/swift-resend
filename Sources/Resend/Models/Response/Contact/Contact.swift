import Foundation

public struct Contact: Decodable {
    
    /// The Contact ID.
    public var id: String
    /// The email address of the contact.
    public var email: String
    /// The first name of the contact.
    public var firstName: String?
    /// The last name of the contact.
    public var lastName: String?
    /// The Contact's global subscription status.
    public var unsubscribed: Bool
    /// Created date of the contact
    public var createdAt: Date
    /// Custom property keys and string values when present.
    public var properties: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case unsubscribed
        case createdAt = "created_at"
        case properties
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        unsubscribed = try container.decode(Bool.self, forKey: .unsubscribed)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        properties = try container.decodeIfPresent([String: String].self, forKey: .properties)
    }
}
