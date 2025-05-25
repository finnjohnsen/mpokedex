//
//  mpokedexApp.swift
//  mpokedex
//
//  Created by Finn J Johnsen on 23/05/2025.
//

import SwiftUI
import SwiftData

@main
struct mpokedexApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Pokemon.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RandomPokemonView()
        }
        .modelContainer(sharedModelContainer)
    }
}
