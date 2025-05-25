import SwiftUI
import SwiftData


struct MainView: View {
    private enum LoadingState { case initializing, loadingData, ready }
    @Environment(\.modelContext) private var modelContext
    var repo: PokemonDataLoader
    @Query var pokemonList : [Pokemon]
    @State private var loadingState: LoadingState = .initializing

    var body: some View {
        NavigationStack {
            VStack {
                if (loadingState != .ready) {
                    ProgressView()
                }
                NavigationStack {
                    NavigationLink(destination: KidsView()) {
                        Text("Kid")
                    }
                    if (pokemonList.count > 0 && loadingState == .ready) {
                        NavigationLink(destination: ParentsView(repo: repo, pokemonList: pokemonList)) {
                            Text("Parents")
                        }
                    }
                }
            }
            .toolbarTitleMenu {
                NavigationLink {
                    KidsView()
                } label: {
                    Text("Kid")
                }
                if pokemonList.count > 0 {
                    NavigationLink {
                        ParentsView(repo: repo, pokemonList: pokemonList)
                    } label: {
                        Text("Parent view")
                    }
                }
                Button("Wipe data") {
                    wipePokemon()
                }.buttonStyle(.borderedProminent)
                
                Button("Fetch data") {
                    initializeState()
                }.buttonStyle(.borderedProminent)
                Text("Pokemon loaded \(pokemonList.count)")

            }
            .toolbarColorScheme(.light, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Pokédex")
            
            .padding()
        }

        .task {
            //repo = PokemonDataLoaderService(modelContext: modelContext)
            initializeState()
        }
    }
    private func initializeState()  {
        Task {
            do {
                loadingState = .loadingData
                try await repo.loadPokemonIfNeeded()
                loadingState = .ready
            } catch {
            }
        }
    }
    private func wipePokemon() {
        Task {
            do {
                try await repo.wipePokemon()
                loadingState = .initializing
            } catch {
                
            }
        }
    }
}

actor NoopDataLoader: PokemonDataLoader {
    func fetchPokemonDetails(pokemon: Pokemon) async throws -> Pokemon {
        return Pokemon(name: "Pikachu", imageUrl: "")
    }
    
    func loadPokemonIfNeeded() async throws {}
    func wipePokemon() async throws {}
        
}

#Preview("Has pokemon data") {
    @Previewable @Query var pokemonPreviewList : [Pokemon]
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let previewContainer = try! ModelContainer(for: Pokemon.self, configurations: config)
    let pokemon = Pokemon(name: "Pikachu")
    
    previewContainer.mainContext.insert(pokemon)
    return MainView(repo: NoopDataLoader())
        .modelContainer(previewContainer)
}
