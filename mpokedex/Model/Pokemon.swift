import Foundation
import SwiftData

/*
 Modellen vår. Den er uavhengig av eksterne REST/GraphQL/Swift-lib og skal dekke behovet i App-en og utvides etterhvert som en bygger ut med datafangst fra APIet.
 
 Vi har giftet os med SwiftData/@Model. Dette er uvisst om er lurt. Vi persisterer _alle_ pokemons med navn ved oppstart av App-en. Det synes jeg fungerer bra.
 
 Men, resten av modellen berikes fra PokeAPI i runtime etter behov. Derfor er muligens modellen litt på avveie og muligens splittes i rein SwiftData domene og et domene som berikes.

 */

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
