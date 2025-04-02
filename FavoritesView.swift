//
//  FavoritesView.swift
//  ChapmanChow
//
//  Created by Irene Ichwan on 4/1/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var favorites: [MenuItem] = []
    
    var body: some View {
        ZStack {
            // Chapman red background
            Color(red: 157/255, green: 34/255, blue: 53/255)
                .ignoresSafeArea()
            
            if favorites.isEmpty {
                Text("No favorites yet!\nLike items from the menu to save them here.")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List {
                    ForEach(favorites) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(item.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                removeFromFavorites(item)
                            }) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .onDelete(perform: removeFavorites)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            loadFavorites()
        }
    }
    
    private func loadFavorites() {
        // In a real app, you would load from persistent storage
        favorites = UserDefaults.standard.loadFavorites()
    }
    
    private func removeFromFavorites(_ item: MenuItem) {
        favorites.removeAll { $0.id == item.id }
        saveFavorites()
    }
    
    private func removeFavorites(at offsets: IndexSet) {
        favorites.remove(atOffsets: offsets)
        saveFavorites()
    }
    
    private func saveFavorites() {
        UserDefaults.standard.saveFavorites(favorites)
    }
}

// Add these extensions to your project
extension UserDefaults {
    func saveFavorites(_ items: [MenuItem]) {
        if let encoded = try? JSONEncoder().encode(items) {
            set(encoded, forKey: "savedFavorites")
        }
    }
    
    func loadFavorites() -> [MenuItem] {
        if let data = data(forKey: "savedFavorites"),
           let decoded = try? JSONDecoder().decode([MenuItem].self, from: data) {
            return decoded
        }
        return []
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoritesView()
                .environmentObject(AuthViewModel())
        }
    }
}
