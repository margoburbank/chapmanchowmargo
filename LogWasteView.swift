//
//  LogWasteView.swift
//  ChapmanChow
//
//  Created by Irene Ichwan on 4/1/25.
//

import SwiftUI

struct WasteLog: Identifiable, Codable {
    let id: UUID
    let itemsWasted: String
    let quantity: String
    let notes: String
    let date: Date
}

struct LogWasteView: View {
    @Environment(\.dismiss) var dismiss
    @State private var itemsWasted = ""
    @State private var quantity = ""
    @State private var notes = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ZStack {
            // Chapman red background
            Color(red: 157/255, green: 34/255, blue: 53/255)
                .ignoresSafeArea()
            
            Form {
                Section(header: Text("Waste Details").foregroundColor(.white)) {
                    TextField("Items Wasted (comma separated)", text: $itemsWasted)
                    TextField("Estimated Quantity", text: $quantity)
                    
                }
                
                Section(header: Text("Additional Notes").foregroundColor(.white)) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 150)
                        .overlay(
                            notes.isEmpty ?
                            Text("Enter any observations about why this was wasted...")
                                .foregroundColor(.gray.opacity(0.5))
                                .padding(.leading, 4)
                                .allowsHitTesting(false)
                            : nil,
                            alignment: .topLeading
                        )
                }
                
                Section {
                    Button(action: submitWasteLog) {
                        Text("Submit Waste Log")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(itemsWasted.isEmpty || quantity.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .foregroundColor(.white)
            .navigationTitle("Log Food Waste")
      
            .alert("Log Submitted", isPresented: $showingConfirmation) {
                Button("OK") { dismiss() }
            } message: {
                Text("Thank you for helping reduce food waste!")
            }
        }
    }
    
    private func submitWasteLog() {
        let newLog = WasteLog(
            id: UUID(),
            itemsWasted: itemsWasted,
            quantity: quantity,
            notes: notes,
            date: Date()
        )
        
        // Save to UserDefaults (replace with API call in production)
        var currentLogs = UserDefaults.standard.loadWasteLogs()
        currentLogs.append(newLog)
        UserDefaults.standard.saveWasteLogs(currentLogs)
        
        showingConfirmation = true
    }
}

// UserDefaults extensions for persistence
extension UserDefaults {
    func saveWasteLogs(_ logs: [WasteLog]) {
        if let encoded = try? JSONEncoder().encode(logs) {
            set(encoded, forKey: "wasteLogs")
        }
    }
    
    func loadWasteLogs() -> [WasteLog] {
        if let data = data(forKey: "wasteLogs"),
           let decoded = try? JSONDecoder().decode([WasteLog].self, from: data) {
            return decoded
        }
        return []
    }
}

struct LogWasteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LogWasteView()
        }
    }
}
