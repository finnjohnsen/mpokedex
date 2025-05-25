import Foundation
import SwiftData
import PokemonAPI

/*
 Har to ansvar :/
 
 Kunne funnet en måte å splitte i API-loading fra SwiftData-greier.
 */

// TODO: arv fra ModelActor for å fikse warning (og random kræsj?)
protocol PokemonDataLoader { // :ModelActor{
    func loadPokemonIfNeeded() async throws
    func wipePokemon() async throws
    func fetchPokemonDetails(pokemon: Pokemon) async throws  -> Pokemon
}

actor PokemonDataLoaderService: PokemonDataLoader {
    private let service = PokemonAPI().pokemonService
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    private func getPokemonCount() -> Int {
        let descriptor = FetchDescriptor<Pokemon>()
        do {
            return try modelContext.fetchCount(descriptor)
        } catch {
            return 0
        }
    }
    
    public func fetchPokemonDetails(pokemon: Pokemon) async throws  -> Pokemon {
        let pokemon = try await service.fetchPokemon(pokemon.name)
        
        return Pokemon(
            name: pokemon.name!,
            imageUrl: (pokemon.sprites?.frontDefault ?? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"))
        
        
        // TODO: finn en bedre failover når vi ikke får bildet
    }
    
    public func loadPokemonIfNeeded() async throws {
        if getPokemonCount() == 0 {
            try await fetchAndPersistAllPokemonNames()
        }
    }
    
    public func wipePokemon() async throws {
        try modelContext.delete(model: Pokemon.self)
        try modelContext.save()
    }
    
    private func fetchAndPersistAllPokemonNames() async throws {
        let pagedPokemon = try await service.fetchPokemonList(paginationState: .initial(pageLimit: 2000))
        print("Fetched \(pagedPokemon.count!) pokemon from API")
        let nextPage = try await service.fetchPokemonList(paginationState: .continuing(pagedPokemon, .next))
        if let results = nextPage.results {
            for pokemonRef in results {
                let name = pokemonRef.name!
                let newPokemon = Pokemon(name: name)
                modelContext.insert(newPokemon)
            }
            try modelContext.save()
        }
    }
}

// For Previews
actor NoopDataLoader: PokemonDataLoader {
    func fetchPokemonDetails(pokemon: Pokemon) async throws -> Pokemon {
        return switch pokemon.name {
            case "weedle": Pokemon(name: "weedle", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/13.png")
            case "watchog": Pokemon(name: "watchog", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/505.png")
            default: Pokemon(name: "cryogonal", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/615.png")
        }
    }
    func loadPokemonIfNeeded() async throws {}
    func wipePokemon() async throws {}
        
}
