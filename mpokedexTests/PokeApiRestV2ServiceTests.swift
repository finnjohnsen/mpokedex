import Testing
@testable import mpokedex


@Suite("API integration tests")
struct PokeApiRestV2ServiceTests {
    
    @Test("Get number of Pokémons returns 1302")
    func testGetNumberOfPokemons() async throws {
        // Given
        let service = PokeApiRestV2Service()
        
        // When
        let numberOfPokemons = try await service.getNumberOfPokemons()
        
        // Then
        #expect(numberOfPokemons == 1302, "Expected 1302 Pokémons, but got \(numberOfPokemons)")
    }
} 
