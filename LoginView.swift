import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var showStaffLogin = false
    @State private var loginError = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                Text("ChapmanChow")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                
                // Login Form
                VStack(spacing: 16) {
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                
                // Login Button
                Button("Login") {
                    authViewModel.signIn(username: username, password: password) { success, error in
                        if !success {
                            errorMessage = error
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                // Student Button
                Button("Continue as Student") {
                    authViewModel.studentLogin()
                }
                .buttonStyle(.bordered)
                .tint(.green)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $authViewModel.isAuthenticated) {
                HomeView()
            }
        }
    }
}
