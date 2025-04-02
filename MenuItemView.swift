import SwiftUI

struct MenuItemView: View {
    var item: MenuItem
    @State private var isLiked: Bool? = nil
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Reaction buttons
                HStack(spacing: 12) {
                    // Like button
                    Button(action: { isLiked = isLiked == true ? nil : true }) {
                        Image(systemName: isLiked == true ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(isLiked == true ? .blue : .gray)
                    }
                    
                    // Dislike button
                    Button(action: { isLiked = isLiked == false ? nil : false }) {
                        Image(systemName: isLiked == false ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .foregroundColor(isLiked == false ? .red : .gray)
                    }
                    
                    // Favorite button
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundColor(isFavorite ? .yellow : .gray)
                    }
                }
            }
            
            Text(item.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let calories = extractCalories(from: item.description) {
                Text(calories)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .cornerRadius(10)
        .shadow(radius: 2)
        .onAppear { checkIfFavorite() }
    }
    
    private func extractCalories(from description: String) -> String? {
        // Handle both "200 cal" and "200 -" formats
        let patterns = ["\\d+ cal", "\\d+ -"]
        for pattern in patterns {
            if let range = description.range(of: pattern, options: .regularExpression) {
                let matched = String(description[range])
                return matched.replacingOccurrences(of: "-", with: "cal")
            }
        }
        return nil
    }
    
    private func checkIfFavorite() {
        isFavorite = UserDefaults.standard.loadFavorites().contains { $0.id == item.id }
    }
    
    private func toggleFavorite() {
        isFavorite.toggle()
        var favorites = UserDefaults.standard.loadFavorites()
        
        if isFavorite {
            if !favorites.contains(where: { $0.id == item.id }) {
                favorites.append(item)
            }
        } else {
            favorites.removeAll { $0.id == item.id }
        }
        
        UserDefaults.standard.saveFavorites(favorites)
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample MenuItem for preview
        MenuItemView(item: MenuItem(
            id: UUID(),
            name: "Sample Item",
            description: "200 cal - Delicious sample item"
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

