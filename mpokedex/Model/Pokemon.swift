import Foundation
import SwiftData

@Model
final class Pokemon: Sendable {
    @Attribute(.unique) var name: String
    var imageUrl : String?
    init(name: String) {
        self.name = name
    }
    init(name: String, imageUrl:String) {
        self.name = name
        self.imageUrl = imageUrl

    }
}
