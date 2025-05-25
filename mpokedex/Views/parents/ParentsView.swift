import SwiftUI

struct ParentsView: View {
    private enum LoadingState { case initializing, loadingDetails, ready }
    @State private var loadingState: LoadingState = .initializing
    var repo: PokemonDataLoader
    var pokemonList: [Pokemon]
    @State private var pokemon: Pokemon?
    
    var body: some View {
        VStack {
            if (pokemon?.imageUrl != nil && loadingState == .ready) {
                Text("\(pokemon!.name)")
                AsyncImage(url: URL(string: pokemon!.imageUrl!)) { image in
                    image.scaledToFit()
                } placeholder: {	
                    ProgressView().progressViewStyle(.circular)
                }
                Button(){
                    Task {
                        loadingState = .loadingDetails
                        await rollRandomPokemon()
                    }
                } label: { Image(systemName: "hand.thumbsdown")}
            } else {
                Text("Loading...")
            }
        }
        .task {
            await rollRandomPokemon()
        }
    }
    private func rollRandomPokemon() async {
        do {
            print("PARENT TASK")
            loadingState = .loadingDetails
            let pokemonSkinny = pokemonList[Int.random(in: 0..<pokemonList.count)]
            pokemon = try await repo.fetchPokemonDetails(pokemon: pokemonSkinny)
            print("pokemonDetails for \(pokemon!.name): imageUrl \(pokemon!.imageUrl ?? "")") // TODO: fix et standard image
            loadingState = .ready
        } catch {
            //TODO: lag noe rundt Loadingstate.error
        }
    }
}



//#Preview("Has pokemon data") {
//    @Previewable @Query var pokemonPreviewList : [Pokemon]
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let previewContainer = try! ModelContainer(for: Pokemon.self, configurations: config)
//    let pokemon = Pokemon(name: "Pikachu")
//    
//    previewContainer.mainContext.insert(pokemon)
//    ParentsView(pokemonList: [Pokemon(name: "orthworm")])
//        .modelContainer(previewContainer)
//}
