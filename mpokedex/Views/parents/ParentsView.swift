import SwiftUI
import SwiftData

struct ThrowOrKeepComponent: View {
    var throwMethod : () -> Void
    var keepMethod: () -> Void
    var body : some View {
        HStack {
            Button(){
                throwMethod()

            } label: { Image(systemName: "arrow.3.trianglepath").resizable().scaledToFit().frame(width: 50)}
            Spacer().frame(width: 180)
            Button(
                action:{
                    keepMethod()
                },
                label: {
                    Image(systemName: "hand.thumbsup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .phaseAnimator([false, true]) { content, phase in
                            content
                                .scaleEffect(phase ? 1 : 1.05)
                        }
                })
        }
    }
}

struct ParentsView: View {
    private enum LoadingState { case initializing, loadingDetails, ready, error }
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var loadingState: LoadingState = .initializing
    var repo: PokemonDataLoader
    var pokemonList: [Pokemon]
    @State var pokemon: Pokemon?
    let defaults = UserDefaults.standard
    @State private var thumbClicked: Bool = false
        
    
    var body: some View {
        VStack {
            if let imageUrl = pokemon?.imageUrl  {
                Spacer()
                AsyncImage(url: URL(string: imageUrl), scale: 1.5) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView().progressViewStyle(.circular)
                }
                .scaledToFit()
                Text("\(pokemon!.name)")
                    .font(.largeTitle)
                    .monospacedDigit()
                Spacer()
                ThrowOrKeepComponent(
                    throwMethod:{
                        Task {
                            loadingState = .loadingDetails
                            await rollRandomPokemon()
                        }
                    }, keepMethod: {
                        if let pokemonName = pokemon?.name {
                            print("storing pokemon \(pokemonName)")
                            defaults.set(pokemonName, forKey: SELECTED_POKEMON_KEY)
                            dismiss()
                        }
                    })
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
            loadingState = .loadingDetails
            let pokemonSkinny = pokemonList[Int.random(in: 0..<pokemonList.count)]
            pokemon = try await repo.fetchPokemonDetails(pokemon: pokemonSkinny)
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

#Preview("ThrowOrKeep component") {
    ThrowOrKeepComponent(throwMethod :{}, keepMethod: {})
}
