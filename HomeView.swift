import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var activeDestination: Destination?
    
    enum Destination {
        case menu
        case favorites
        case requestMeal
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Chapman red background
                Color(red: 157/255, green: 34/255, blue: 53/255)
                    .ignoresSafeArea()
                
                // Content
                VStack(spacing: 20) {
                    Text("Welcome to ChapmanChow!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.top, 50)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        if activeDestination != .menu {
                            HomeButton(
                                title: "View Menu",
                                color: .white,
                                textColor: Color(red: 157/255, green: 34/255, blue: 53/255),
                                action: { activeDestination = .menu }
                            )
                        }
                        
                        if activeDestination != .favorites {
                            HomeButton(
                                title: "Favorites",
                                color: .white,
                                textColor: Color(red: 157/255, green: 34/255, blue: 53/255),
                                action: { activeDestination = .favorites }
                            )
                        }
                        
                        if activeDestination != .requestMeal {
                            HomeButton(
                                title: "Request a Meal",
                                color: .white,
                                textColor: Color(red: 157/255, green: 34/255, blue: 53/255),
                                action: { activeDestination = .requestMeal }
                            )
                        }
                    }
                    .padding(.bottom, 50)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Home")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            
            .navigationDestination(item: $activeDestination) { destination in
                Group {
                    switch destination {
                    case .menu:
                        MenuView()
                    case .favorites:
                        FavoritesView()
                    case .requestMeal:
                        RequestMealView()
                    }
                }
        
            }
        }
        .accentColor(.white) // Makes back button white
    }
}

// HomeButton remains the same as previous implementation
struct HomeButton: View {
    let title: String
    var color: Color = .white
    var textColor: Color = .white
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(textColor)
                .padding()
                .frame(maxWidth: 200)
                .background(color)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// Placeholder views implementation remains the same
