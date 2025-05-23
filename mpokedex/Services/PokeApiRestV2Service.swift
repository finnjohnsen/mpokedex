import Foundation

class PokeApiRestV2Service: PokeApi {
    
    private let baseURL = "https://pokeapi.co/api/v2"
    private let session = URLSession.shared
    
    func getNumberOfPokemons() async throws -> Int {
        guard let url = URL(string: "\(baseURL)/pokemon?limit=1") else {
            throw PokeApiError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw PokeApiError.networkError
            }
            
            let pokemonListResponse = try JSONDecoder().decode(PokemonCountResponse.self, from: data)
            return pokemonListResponse.count
            
        } catch {
            if error is PokeApiError {
                throw error
            } else {
                throw PokeApiError.decodingError
            }
        }
    }
}

// MARK: - Response Models

private struct PokemonCountResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonBasic]
}

private struct PokemonBasic: Codable {
    let name: String
    let url: String
}

// MARK: - Error Types

enum PokeApiError: Error, LocalizedError {
    case invalidURL
    case networkError
    case decodingError
    case pokemonNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .networkError:
            return "Network request failed"
        case .decodingError:
            return "Failed to decode response data"
        case .pokemonNotFound:
            return "Pokémon not found"
        }
    }
} 
