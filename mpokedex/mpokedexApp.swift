//
//  mpokedexApp.swift
//  mpokedex
//
//  Created by Finn J Johnsen on 23/05/2025.
//

import SwiftUI
import SwiftData

/*
 TODO: SwiftData.ModelContext: Unbinding from the main queue. This context was instantiated on the main queue but is being used off it. ModelContexts are not Sendable, consider using a ModelActor.

 */
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
        let repo: PokemonDataLoader = PokemonDataLoaderService(modelContext: modelContainer.mainContext)
        WindowGroup {
            MainView(repo:repo)
          //      .environmentObject(repo)
            //ParentsView(pokemonList: [Pokemon(name: "orthworm")])
        }
        .modelContainer(modelContainer)
        
    }
}
