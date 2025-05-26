import SwiftUI


struct PokemonCardView : View {
    @State var pokemon: Pokemon
    var body: some View {
        ZStack {
            PokeColors.cardColor.cornerRadius(40).offset(y: 12)
            PokeColors.cardColor.cornerRadius(40).offset(y: 3).opacity(0.85)
            LinearGradient(colors:[.clear, PokeColors.cardColor, .clear],
                                         startPoint: .top,
                                         endPoint:.bottom)
            CardContent(pokemon: pokemon)
        }.padding(30)
        
    }
}

private struct CardContent : View {
    @State var pokemon: Pokemon
    
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            Text("\(pokemon.name)")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(
                    LinearGradient(colors: [.red, .black, .red],
                                   startPoint: .top,
                                   endPoint:. bottom)
            )
            Text("Abilities. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                .multilineTextAlignment(.leading)
                .italic()
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.red)
            
            if let imageUrl = self.pokemon.imageUrl {
                ZStack {
                    Circle().fill(LinearGradient(colors:[.clear, .red, .clear],
                                                 startPoint: .topLeading,
                                                 endPoint:.bottomTrailing))
                    .frame(height: 150)
                    AsyncImage(url: URL(string: imageUrl), scale: 1.7) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .frame(width: 300, height: 300)
                            
                        } else if phase.error != nil {
                            Image(systemName: "exclamationmark.questionmark")
                                .frame(width: 300, height: 300)
                        } else {
                            Image(systemName: "questionmark")
                                .frame(width: 300, height: 300)
                        }
                    }
                    .scaledToFit()
                }	
            } else {
                Image(systemName: "questionmark")
            }
        }
        
        .padding(10)
    }
}


#Preview("Fully loaded") {
    PokemonCardView(pokemon: Pokemon(name: "watchog", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/505.png"))
}

#Preview("Waiting for image download") {
    PokemonCardView(pokemon: Pokemon(name: "watchog"))
}
