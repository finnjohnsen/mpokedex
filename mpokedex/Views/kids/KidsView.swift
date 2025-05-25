import SwiftUI
import SwiftData

struct KidsView: View {
    var repo: PokemonDataLoader
    private let pokemon:String
    
    init(repo: PokemonDataLoader, pokemon:String) {
        self.repo = repo
        self.pokemon = pokemon
    }
    
    var body: some View {
        Text("KIDS VIEW \(pokemon)")
    }
}

#Preview("Show pokemon") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let previewContainer = try! ModelContainer(for: Pokemon.self, configurations: config)
    let repo = NoopDataLoader()
    KidsView(repo: repo, pokemon: "weedle")
    
}
