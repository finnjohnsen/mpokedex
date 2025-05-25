import SwiftUI
import SwiftData
import Combine

struct MainView: View {
    private enum LoadingState { case initializing, loadingData, ready }
    @Environment(\.modelContext) private var modelContext
    @State private var repo: PokemonDataLoader?
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
                        NavigationLink(destination: KidsView(repo: repo ?? NoopDataLoader(),
                                                             pokemon: (self.selectedPokemon ?? "")!)) {
                            Image(systemName:"figure.child")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(height: gp.size.height * 0.8)
                        .disabled(selectedPokemon == nil)
                        
                        if (pokemonList.count > 0 && loadingState == .ready) {
                            NavigationLink(destination: ParentsView(repo: repo ?? NoopDataLoader(), pokemonList: pokemonList)) {
                                Image(systemName:"figure.and.child.holdinghands")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }.frame(height: gp.size.height * 0.2)
                        }
                    }
                }
            }
            .toolbarTitleMenu {
                Button("Wipe data") {
                    wipePokemon()
                }.buttonStyle(.borderedProminent)
                Button("Wipe selected") {
                    selectedPokemon = nil
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
            repo = PokemonDataLoaderService()
            initializeState()
        }
    }
    private func initializeState()  {
        Task {
            do {
                guard let repo = repo else { return }
                loadingState = .loadingData
                try await repo.loadPokemonIfNeeded(modelContext: modelContext)
                loadingState = .ready
            } catch {
            }
        }
    }
    private func wipePokemon() {
        Task {
            do {
                guard let repo = repo else { return }
                try await repo.wipePokemon(modelContext: modelContext)
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
    return MainView()
        .modelContainer(previewContainer)
}
