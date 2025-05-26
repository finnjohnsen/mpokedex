import SwiftUI
import SwiftData

struct KidsView: View {
    @Environment(\.modelContext) private var modelContext
    var repo: PokemonDataLoader
    @State var pokemon: Pokemon
    @State var pokemonFull: Pokemon?
    @State var animate: Bool = false
    let defaults = UserDefaults.standard
    
    init(repo: PokemonDataLoader, pokemon:Pokemon) {
        self.repo = repo
        self.pokemon = pokemon
    }

    var body: some View {
        VStack (spacing: 50) {
            if let pokemonFull = pokemonFull {
                PokemonCardView(pokemon: pokemonFull)
            } else {
                PokemonCardView(pokemon: pokemon)
            }

        }.task {
            do {
                pokemonFull = try await repo.fetchPokemonDetails(pokemon: pokemon)
                defaults.set(nil, forKey: SELECTED_POKEMON_KEY)
            } catch {
                // TODO: håndter feilstate
            }
        }
    }
}

#Preview("Show pokemon") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let previewContainer = try! ModelContainer(for: Pokemon.self, configurations: config)
    let repo = NoopDataLoader()
    KidsView(repo: repo, pokemon: Pokemon(name: "weedle"))
    
}
