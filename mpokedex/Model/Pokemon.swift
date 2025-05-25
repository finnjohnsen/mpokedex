import Foundation
import SwiftData

@Model
final class Pokemon {
    @Attribute(.unique) var name: String
    
    var imageUrl : String?
    

    init(name: String) {
        self.name = name

    }
}
