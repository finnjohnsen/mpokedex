import SwiftUI
import SwiftData
import Combine

struct MainView: View {
    private enum LoadingState { case initializing, loadingData, ready }
    @Environment(\.modelContext) private var modelContext
    var repo: PokemonDataLoader
    @Query var pokemonList: [Pokemon]
    @State private var loadingState: LoadingState = .initializing
    @AppStorage(SELECTED_POKEMON_KEY) var selectedPokemon: String?
    
    var body: some View {
        NavigationStack {
            GeometryReader { gp in
                VStack {
                    if (loadingState != .ready) {
                        ProgressView()
                    }
                    NavigationStack {
                        NavigationLink(destination: KidsView(repo: repo,
                                                             pokemon: (self.selectedPokemon ?? "")!)) {
                            Image(systemName:"figure.child")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(height: gp.size.height * 0.8)
                        .disabled(selectedPokemon == nil)
                        
                        if (pokemonList.count > 0 && loadingState == .ready) {
                            NavigationLink(destination: ParentsView(repo: repo, pokemonList: pokemonList)) {
                                Image(systemName:"figure.and.child.holdinghands")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }.frame(height: gp.size.height * 0.2)
                        }
                    }
                }
            }
            .toolbarTitleMenu {
                NavigationLink {
                    KidsView(repo: repo, pokemon: (self.selectedPokemon ?? "")!)
                        .disabled(self.selectedPokemon == nil)
                } label: {
                    Text("Kid")
                }
                if pokemonList.count > 0 {
                    NavigationLink {
                        ParentsView(repo: repo,
                                    pokemonList: pokemonList)
                    } label: {
                        Text("Parent")
                    }
                }
                Button("Wipe data") {
                    wipePokemon()
                }.buttonStyle(.borderedProminent)
                
                Button("Fetch data") {
                    initializeState()
                }.buttonStyle(.borderedProminent)
                Text("Pokemon loaded \(pokemonList.count)")
                if let selectedPokemon {
                    Text("Selected pokemon \(selectedPokemon ?? "none" )")

                } else {
                    Text("No selected pokemon yet")

                }

                
            }
            .toolbarColorScheme(.light, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Pokédex")
            
            .padding()
        }

        .task {
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
    private func toolbar() {
        
    }
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
