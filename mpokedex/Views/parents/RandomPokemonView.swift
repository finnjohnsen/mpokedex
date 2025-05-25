import SwiftUI
import SwiftData
import PokemonAPI

struct RandomPokemonView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pokemonList : [Pokemon]
    
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    @State private var randomInt: Int?
    @State private var repo: PokemonDataLoaderService?
    
    init() {}
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Pokemons \(pokemonList.count)")
            
            Button("Reload data") {
                loadData()
            }
            
            Button("Wipe data") {
                do {
                    try wipePokemon()
                } catch {
                    
                }
            }
            
            if (pokemonList.count > 0 && randomInt != nil) {
                Text("Random Pokemon \(pokemonList[randomInt!].name)")
                Button("Random") {
                    randomInt = Int.random(in: 0..<pokemonList.count)
                }
            }
            
        }
        .task {
            repo = PokemonDataLoaderService(modelContext: modelContext)
            loadData()
        }
    }
    
    private func loadData()  {
        Task {
            do {
                guard let repo = repo else { return }
                try await repo.loadPokemonIfNeeded()
                if pokemonList.count > 0 {
                    randomInt = Int.random(in: 0..<pokemonList.count)
                }
            } catch {
            }
        }
    }
    
    private func wipePokemon() throws{
        Task {
            guard let repo = repo else { return }
            try repo.wipePokemon()
        }
    }
}

//#Preview("Success") {
//    RandomPokemonView(pokeService: PokeApiPreview())
//}
