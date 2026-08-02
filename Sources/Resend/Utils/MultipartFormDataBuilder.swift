import Foundation

/// Builds an `application/multipart/form-data` body for AsyncHTTPClient.
struct MultipartFormDataBuilder {
    let boundary: String
    private var body = Data()
    
    init(boundary: String = "Boundary-\(UUID().uuidString)") {
        self.boundary = boundary
    }
    
    var contentType: String {
        "multipart/form-data; boundary=\(boundary)"
    }
    
    mutating func appendField(name: String, value: String) {
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        append(value)
        append("\r\n")
    }
    
    mutating func appendFile(
        name: String,
        filename: String,
        mimeType: String,
        data: Data
    ) {
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        append("\r\n")
    }
    
    mutating func finalize() -> Data {
        append("--\(boundary)--\r\n")
        return body
    }
    
    private mutating func append(_ string: String) {
        body.append(Data(string.utf8))
    }
}
