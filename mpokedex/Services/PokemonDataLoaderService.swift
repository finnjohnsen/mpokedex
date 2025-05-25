import Foundation
import SwiftData
import PokemonAPI

/*
 Har to ansvar :/	
 
 Kunne funnet en måte å splitte i API-loading fra SwiftData-greier.
 */
actor PokemonDataLoaderService {
    private let service = PokemonAPI().pokemonService
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getPokemonCount() -> Int {
        let descriptor = FetchDescriptor<Pokemon>()
        do {
            return try modelContext.fetchCount(descriptor)
        } catch {
            return 0
        }
    }
    
    func getAllPokemon() -> [Pokemon] {
        let descriptor = FetchDescriptor<Pokemon>()
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            return []
        }
    }
    
    func loadPokemonIfNeeded() async throws {
        if getPokemonCount() == 0 {
            try await fetchAndPersistAllPokemonNames()
        }
    }
    
    func wipePokemon() throws {
        try modelContext.delete(model: Pokemon.self)
        try modelContext.save()
    }
    
    private func fetchAndPersistAllPokemonNames() async throws {
        let pagedPokemon = try await service.fetchPokemonList(paginationState: .initial(pageLimit: 2000))
        print(" Total \(pagedPokemon.count!)")
        let nextPage = try await service.fetchPokemonList(paginationState: .continuing(pagedPokemon, .next))
        if let results = nextPage.results {
            for pokemonRef in results {
                let name = pokemonRef.name!
                let newPokemon = Pokemon(name: name)
                print("Lagrer \(newPokemon)" )
                modelContext.insert(newPokemon)
            }
            try modelContext.save()
        }
    }
}
