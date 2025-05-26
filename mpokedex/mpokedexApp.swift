//
import SwiftUI
import SwiftData

@main
struct mpokedexApp: App {

    var modelContainer: ModelContainer = {
        let schema = Schema([Pokemon.self])
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(modelContainer)
        
    }
}

let SELECTED_POKEMON_KEY:String = "mpokedex.selectedPokemon"
