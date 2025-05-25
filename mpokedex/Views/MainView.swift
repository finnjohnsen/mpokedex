import SwiftUI
import SwiftData

enum LoadingState { case initializing, loadingData, ready }


struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pokemonList : [Pokemon]

    @State private var repo: PokemonDataLoaderService?
    @State private var loadingState: LoadingState = .initializing
    @State private var randomInt: Int?

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
                    NavigationLink(destination: ParentsView()) {
                        Text("Parents")
                    }
                }
            }
            .toolbarTitleMenu {
                NavigationLink {
                    KidsView()
                } label: {
                    Text("Kid")
                }
                NavigationLink {
                    ParentsView()
                } label: {
                    Text("Parent view")
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
            repo = PokemonDataLoaderService(modelContext: modelContext)
            initializeState()
        }
    }
    private func initializeState()  {
        Task {
            do {
                guard let repo = repo else { return }
                loadingState = .loadingData
                try await repo.loadPokemonIfNeeded()
                if pokemonList.count > 0 {
                    randomInt = Int.random(in: 0..<pokemonList.count)
                }
                loadingState = .ready
            } catch {
            }
        }
    }
    private func wipePokemon() {
        Task {
            do {
                guard let repo = repo else { return }
                try await repo.wipePokemon()
                loadingState = .initializing
            } catch {
                
            }
        }
    }
}

#Preview {
    MainView()
}
