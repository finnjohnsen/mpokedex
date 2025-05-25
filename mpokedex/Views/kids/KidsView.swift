import SwiftUI
import SwiftData

struct KidsView: View {
    @Environment(\.modelContext) private var modelContext
    var repo: PokemonDataLoader
    @State var pokemonName:String
    @State var pokemon: Pokemon?
    @State var animate: Bool = false
    let defaults = UserDefaults.standard
    
    init(repo: PokemonDataLoader, pokemon:String) {
        self.repo = repo
        self.pokemonName = pokemon
    }

    var body: some View {
        VStack (spacing: 50) {
            Text("\(self.pokemonName)")
                .font(.system(size:44, weight: .bold))
                .monospacedDigit()

            
            if let imageUrl = self.pokemon?.imageUrl {
                AsyncImage(url: URL(string: imageUrl), scale: 1.7) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            
                    } else if phase.error != nil {
                        Color.red
                    } else {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
                .scaledToFit()

            }

        }.task {
            do {
                pokemon = try await repo.fetchPokemonDetails(pokemon: Pokemon(name: pokemonName))
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
    KidsView(repo: repo, pokemon: "weedle")
    
}
