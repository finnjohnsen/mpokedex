import SwiftUI
import SwiftData


struct RandomPokemonView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var errorMessage: String?
    @State private var repo: PokemonDataLoaderService?
    
    init() {}
    
    var body: some View {
        VStack(spacing: 20) {
//            Text("Pokemons \(pokemonList.count)")
//            
//
//            Button("Reload data") {
//                initializeState()
//            }
//            
//            Button("Wipe data") {
//                do {
//                    try wipePokemon()
//                } catch {}
//            }
//            
//            switch loadingState {
//                case .initializing:
//                    Text("Starting...")
//                case .loadingData:
//                    Text("Loading data...")
//                case .ready:
//                    if (pokemonList.count > 0 && randomInt != nil) {
//                        // unneccesary nil/empty checks?
//                        Text("Random Pokemon \(pokemonList[randomInt!].name)")
//                        Button("Random") {
//                            randomInt = Int.random(in: 0..<pokemonList.count)
//                        }
//                    } else {
//                        
//                    }
//            }
            
            
        }
        .task {
//            repo = PokemonDataLoaderService(modelContext: modelContext)
//            initializeState()
        }
    }
    
//    private func initializeState()  {
//        Task {
//            do {
//                guard let repo = repo else { return }
//                loadingState = .loadingData
//                try await repo.loadPokemonIfNeeded()
//                if pokemonList.count > 0 {
//                    randomInt = Int.random(in: 0..<pokemonList.count)
//                }
//                loadingState = .ready
//            } catch {
//            }
//        }
//    }
    
    private func wipePokemon() throws{
        Task {
            guard let repo = repo else { return }
            try await repo.wipePokemon()
        }
    }
}

//#Preview("Success") {
//    RandomPokemonView(pokeService: PokeApiPreview())
//}
