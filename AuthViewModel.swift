import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var isStaff = false
    
    init() {
        self.user = Auth.auth().currentUser
        self.isAuthenticated = user != nil
        // Check staff status on init
        self.isStaff = UserDefaults.standard.bool(forKey: "isStaff")
    }
    
    func signIn(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        // Staff login check (case insensitive)
        if username.lowercased() == "randallstaff" && password == "gci" {
            self.isAuthenticated = true
            self.isStaff = true
            UserDefaults.standard.set(true, forKey: "isStaff")
            completion(true, nil)
            return
        }
        
        // Regular Firebase login
        Auth.auth().signIn(withEmail: username, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                self.user = result?.user
                self.isAuthenticated = true
                self.isStaff = false
                UserDefaults.standard.set(false, forKey: "isStaff")
                completion(true, nil)
            }
        }
    }
    
    func studentLogin() {
        self.isAuthenticated = true
        self.isStaff = false
        UserDefaults.standard.set(false, forKey: "isStaff")
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
            self.isStaff = false
            UserDefaults.standard.set(false, forKey: "isStaff")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
