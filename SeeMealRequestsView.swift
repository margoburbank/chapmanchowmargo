import SwiftUI

struct SeeMealRequestsView: View {
    @State private var requests: [MealRequest] = []
    @State private var showingFileLocation = false
    
    var body: some View {
        ZStack {
            Color(red: 157/255, green: 34/255, blue: 53/255)
                .ignoresSafeArea()
            
            if requests.isEmpty {
                VStack {
                    Text("No meal requests yet")
                        .foregroundColor(.white)
                    
                    // Debug button to show file location
                    Button("Show Data File Location") {
                        showingFileLocation = true
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    .padding()
                }
            } else {
                List {
                    ForEach($requests) { $request in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("\(request.firstName) \(request.lastName)")
                                    .font(.headline)
                                Spacer()
                                statusBadge(request.status)
                            }
                            
                            Text("ID: \(request.studentID)")
                            Text(request.mealRequest)
                                .font(.subheadline)
                            Text(request.date.formatted())
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            if request.status == .pending {
                                HStack {
                                    Button("Approve") {
                                        updateRequest(request, status: .approved)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.green)
                                    
                                    Button("Deny") {
                                        updateRequest(request, status: .denied)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.red)
                                }
                            } else if request.status == .approved {
                                Button("Mark as Completed") {
                                    updateRequest(request, status: .completed)
                                }
                                .buttonStyle(.bordered)
                                .tint(.blue)
                            }
                        }
                        .padding(.vertical, 8)
                        .swipeActions {
                            Button(role: .destructive) {
                                deleteRequest(request)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Meal Requests")
        .onAppear {
            loadRequests()
        }
        .alert("Data Saved", isPresented: $showingFileLocation) {
            Button("OK") {}
        } message: {
            Text("Meal requests saved successfully")
        }
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                refreshButton
            }
            #else
            ToolbarItem(placement: .automatic) {
                            }
            #endif
        }
    }
    
    // MARK: - View Components
    private func statusBadge(_ status: MealRequest.RequestStatus) -> some View {
        Text(status.rawValue.capitalized)
            .font(.caption)
            .padding(5)
            .background(statusColor(status))
            .foregroundColor(.white)
            .cornerRadius(5)
    }
    
    private func statusColor(_ status: MealRequest.RequestStatus) -> Color {
        switch status {
        case .pending: return .gray
        case .approved: return .green
        case .denied: return .red
        case .completed: return .blue
        }
    }
    
    // MARK: - Data Management
    private func loadRequests() {
        requests = MealRequestManager.shared.loadAllRequests()
        print("Loaded \(requests.count) requests")
    }
    
    private func updateRequest(_ request: MealRequest, status: MealRequest.RequestStatus) {
        var allRequests = MealRequestManager.shared.loadAllRequests()
        if let index = allRequests.firstIndex(where: { $0.id == request.id }) {
            allRequests[index].status = status
            MealRequestManager.shared.saveAllRequests(allRequests)
            print("Updated request status to \(status.rawValue)")
        }
        loadRequests() // Refresh the view
    }
    
    private func deleteRequest(_ request: MealRequest) {
        var allRequests = MealRequestManager.shared.loadAllRequests()
        allRequests.removeAll { $0.id == request.id }
        MealRequestManager.shared.saveAllRequests(allRequests)
        print("Deleted request")
        loadRequests() // Refresh the view
    }
}
