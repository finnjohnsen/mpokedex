import Foundation
import SwiftData

@Model final class Pokemon: Sendable {
    @Attribute(.unique) var name: String
    var imageUrl : String?
    var abilities : [Ability] = []
    init(name: String) {
        self.name = name
    }
    init(name: String, imageUrl:String) {
        self.name = name
        self.imageUrl = imageUrl
        self.abilities = [Ability]()

    }
}

@Model final class Ability: Sendable {
    @Attribute(.unique) var name: String
    var effect: String?
    init(name: String) {
        self.name = name
    }
    init(name: String, effect: String) {
        self.name = name
        self.effect = effect
    }
}
