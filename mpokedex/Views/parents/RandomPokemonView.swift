import SwiftUI

struct RandomPokemonView: View {
    @State private var numberOfPokemons: Int = 0
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    
    private let pokeService: PokeApi
    
    init(pokeService: PokeApi = PokeApiRestV2Service()) {
        self.pokeService = pokeService
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView()
                Text("Fetching Pokémon data...")
            } else if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                Button("Retry") {
                    fetchNumberOfPokemons()
                }
            } else {
                Text("Total Pokémon: \(numberOfPokemons)")
                    .font(.title2)
                    .fontWeight(.semibold)
                
            }
        }
        .task {
            fetchNumberOfPokemons()
        }
    }
    
    private func fetchNumberOfPokemons() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let count = try await pokeService.getNumberOfPokemons()
                await MainActor.run {
                    numberOfPokemons = count
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

struct PokeApiPreview: PokeApi {
    func getNumberOfPokemons() async throws -> Int {
        return 1000
    }
}

#Preview {
    RandomPokemonView(pokeService: PokeApiPreview())
}
