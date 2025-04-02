import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                if authViewModel.isStaff {
                    StaffHomeView()
                } else {
                    HomeView()
                }
            } else {
                LoginView()
            }
        }
    }
}
