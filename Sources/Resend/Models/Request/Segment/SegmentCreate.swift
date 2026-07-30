import Foundation

struct SegmentCreate: Encodable {
    
    /// The name of the segment you want to create.
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
