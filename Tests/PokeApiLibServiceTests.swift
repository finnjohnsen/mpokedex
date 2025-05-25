import Testing
import PokemonAPI

typealias PokemonLibAPI = PokemonAPI


@Suite("PokeLib integration tests")
struct PokeApiLibServiceTests {
    let api = PokemonLibAPI()
    
    @Test("Fetching a Pokemon works")
    func fetchPokemon() async throws {
        do {
            let pokemon = try await api.pokemonService.fetchPokemon("bulbasaur")
            print("POKEMON \(pokemon.sprites?.frontDefault)")
            try #require(pokemon.name! == "bulbasaur")
            

        } catch {
            print(error.localizedDescription)
        }

        print("done")
    }
}
