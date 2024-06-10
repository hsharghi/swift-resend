import Foundation

public struct EmailHeaders: Codable {
    
    /// The name of the email custom header.
    public var name: String
    
    /// The value of the custom header.
    public var value: String?
    
    init(name: String, value: String?) {
        self.name = name
        self.value = value
    }
       
}

extension Array where Element == EmailHeaders {
    var objectArray: [String: String?] {
        var headersObject = [String: String?]()
        self.forEach { header in
            headersObject[header.name] = header.value
        }
        return headersObject
    }
}
