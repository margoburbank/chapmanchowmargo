import SwiftUI
import FirebaseCore

@main
struct ChapmanChowApp: App {
    @StateObject var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            NavigationView {
                RootView()
                    .environmentObject(authViewModel)
            }
            .navigationViewStyle(.stack)
            #else
            // For macOS and other platforms
            RootView()
                .environmentObject(authViewModel)
                .frame(minWidth: 800, minHeight: 600) // Optional: Set minimum window size
            #endif
        }
    }
}
