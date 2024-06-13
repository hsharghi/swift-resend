import Foundation

public struct EmailTags: Codable {
    
    /// The name of the email tag.
    /// It can only contain ASCII letters (a–z, A–Z), numbers (0–9), underscores (_), or dashes (-).
    /// It can contain no more than 256 characters
    public var name: String
    
    /// The value of the email tag.
    /// It can only contain ASCII letters (a–z, A–Z), numbers (0–9), underscores (_), or dashes (-).
    /// It can contain no more than 256 characters.
    public var value: String?
    
    public init(name: String, value: String?) {
        self.name = name
        self.value = value
    }
}
