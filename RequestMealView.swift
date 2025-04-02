import SwiftUI

struct RequestMealView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var studentID = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var requestedMeal = ""
    @State private var showConfirmation = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    let maroon = Color(red: 157/255, green: 34/255, blue: 53/255)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            maroon.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Request a Meal")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        // Student Information Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Student Information")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            CustomTextField(placeholder: "Student ID", text: $studentID)
                            CustomTextField(placeholder: "First Name", text: $firstName)
                            CustomTextField(placeholder: "Last Name", text: $lastName)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Meal Request Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Meal Request")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextEditor(text: $requestedMeal)
                                .frame(height: 100)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .background(Color.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 100)
            }
            
            // Submit Button
            Button(action: submitRequest) {
                Text("Submit Request")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(maroon)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .shadow(radius: 5)
        }
        .navigationTitle("")
        .alert("Request Submitted", isPresented: $showConfirmation) {
            Button("OK", role: .cancel) {
                resetForm()
            }
        } message: {
            Text("Your meal request has been submitted for approval.")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // Custom Text Field Component
    struct CustomTextField: View {
        var placeholder: String
        @Binding var text: String
        
        var body: some View {
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    private func submitRequest() {
        // Validate inputs
        guard !studentID.isEmpty else {
            errorMessage = "Please enter your student ID"
            showError = true
            return
        }
        
        guard !firstName.isEmpty && !lastName.isEmpty else {
            errorMessage = "Please enter your full name"
            showError = true
            return
        }
        
        guard !requestedMeal.isEmpty else {
            errorMessage = "Please describe your meal request"
            showError = true
            return
        }
        
        // Create and save the request using the existing updateRequestStatus method
        let newRequest = MealRequest(
                id: UUID(),
                studentID: studentID,
                firstName: firstName,
                lastName: lastName,
                mealRequest: requestedMeal,
                date: Date(),
                status: .pending
            )
            
            var allRequests = MealRequestManager.shared.loadAllRequests()
            allRequests.append(newRequest)
            MealRequestManager.shared.saveAllRequests(allRequests) // Use the new method
            
            showConfirmation = true
            resetForm()
            
            // Debug
            print("Current requests:", allRequests.map { $0.mealRequest })
    }
    
    private func resetForm() {
        studentID = ""
        firstName = ""
        lastName = ""
        requestedMeal = ""
    }
}

// Preview Provider
struct RequestMealView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RequestMealView()
                .environmentObject(AuthViewModel())
        }
    }
}
