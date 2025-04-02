//
//  MealRequest.swift
//  ChapmanChow
//
//  Created by Irene Ichwan on 4/2/25.
//


import Foundation

struct MealRequest: Identifiable, Codable {
    let id: UUID
    let studentID: String
    let firstName: String
    let lastName: String
    let mealRequest: String
    let date: Date
    var status: RequestStatus
    
    enum RequestStatus: String, Codable {
        case pending, approved, denied, completed
    }
}

class MealRequestManager {
    static let shared = MealRequestManager()
    private let requestsURL = URL(fileURLWithPath: "/Users/ireneichwan/Desktop/ChapmanChow/ChapmanChow/mealRequests.json")
    
    // Add this new method
    func saveAllRequests(_ requests: [MealRequest]) {
        do {
            let data = try JSONEncoder().encode(requests)
            try data.write(to: requestsURL)
            print("Saved \(requests.count) requests to \(requestsURL.path)")
        } catch {
            print("Error saving requests: \(error)")
        }
    }
    func loadAllRequests() -> [MealRequest] {
        do {
            let data = try Data(contentsOf: requestsURL)
            return try JSONDecoder().decode([MealRequest].self, from: data)
        } catch {
            print("Error loading requests: \(error)")
            return []
        }
    }
    
    func updateRequestStatus(for requestID: UUID, to status: MealRequest.RequestStatus) {
        var allRequests = loadAllRequests()
        if let index = allRequests.firstIndex(where: { $0.id == requestID }) {
            allRequests[index].status = status
            saveRequests(allRequests)
        }
    }
    
    func deleteRequest(_ requestID: UUID) {
        var allRequests = loadAllRequests()
        allRequests.removeAll { $0.id == requestID }
        saveRequests(allRequests)
    }
    
    private func saveRequests(_ requests: [MealRequest]) {
        do {
            let data = try JSONEncoder().encode(requests)
            try data.write(to: requestsURL)
        } catch {
            print("Error saving requests: \(error)")
        }
    }
}
