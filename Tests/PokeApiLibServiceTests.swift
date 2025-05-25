import Testing
import PokemonAPI

typealias PokemonLibAPI = PokemonAPI

// set to 0 to run all:
let runTestsAbove = 0

@Suite("PokeLib integration tests")
struct PokeApiLibServiceTests {
    let api = PokemonLibAPI()
    
    @Test("Fetch ability", .enabled(if: runTestsAbove <= 1))
    func fetchAbility() async throws {
        let ability = try await api.pokemonService.fetchAbility("drizzle")
        var effectStr:String?
        if let effectEntries = ability.effectEntries?.filter {e in
            e.language?.name == "en"}{
            effectStr = effectEntries[0].shortEffect!
        }
        #expect(effectStr == "Summons rain that lasts indefinitely upon entering battle.")
    }
    
    @Test("Fetching a Pokemon works", .enabled(if: runTestsAbove <= 0))
    func fetchPokemon() async throws {
        do {
            let pokemon = try await api.pokemonService.fetchPokemon("bulbasaur")
            var abilityNames = [String]()
            if let abilitiesList = pokemon.abilities {
                for abilityRef in abilitiesList {
                    if let abilityName = abilityRef.ability?.name {
                        abilityNames.append(abilityName)
                    }
                }
            }

            try #require(abilityNames == ["overgrow", "chlorophyll"])
            try #require(pokemon.name! == "bulbasaur")
            try #require(pokemon.sprites?.frontDefault == "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")

        } catch {
            print(error.localizedDescription)
        }

        print("done")
    }
}
