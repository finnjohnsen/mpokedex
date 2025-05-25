import SwiftUI
import SwiftData

struct ParentsView: View {
    private enum LoadingState { case initializing, loadingDetails, ready, error }
    @State private var loadingState: LoadingState = .initializing
    var repo: PokemonDataLoader
    var pokemonList: [Pokemon]
    @State  var pokemon: Pokemon?
    let defaults = UserDefaults.standard
    
    var body: some View {
        VStack {
            if let imageUrl = pokemon?.imageUrl  {
                Text("\(pokemon!.name)")
                Spacer()
                AsyncImage(url: URL(string: imageUrl), scale: 1.5) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView().progressViewStyle(.circular)
                }
                .scaledToFit()
                Spacer()
                HStack {
                    Button(){
                        Task {
                            loadingState = .loadingDetails
                            await rollRandomPokemon()	
                        }
                    } label: { Image(systemName: "trash").resizable().scaledToFit().frame(width: 50)}
                    Spacer().frame(width: 40)
                    Button(
                        action:{
                            if let pokemonName = pokemon?.name {
                                print("storing pokemon \(pokemonName)")
                                defaults.set(pokemonName, forKey: SELECTED_POKEMON_KEY)
                            }
                        },
                        label: { Image(systemName: "hand.thumbsup").resizable().scaledToFit().frame(width: 50)})
                }
            } else {
                Text("Loading...")
            }
            if (loadingState == .error) {
                Text("No pokemon found :(")
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
            print("Crash during pokemon fetch : \(error)")
            loadingState = .error
        }
    }
}



#Preview("Show pokemon") {
    //@Previewable @Query var pokemonPreviewList : [Pokemon]
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let previewContainer = try! ModelContainer(for: Pokemon.self, configurations: config)

   // previewContainer.mainContext.insert(pokemon)
    let repo = NoopDataLoader()
    ParentsView(repo: repo, pokemonList: [
        Pokemon(name: "cryogonal"),
        Pokemon(name: "watchog"),
        Pokemon(name: "weedle")])
        .modelContainer(previewContainer)
}
