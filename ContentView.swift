//
//  ContentView.swift
//  ChapmanChow
//
//  Created by Irene Ichwan on 2/12/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    var body: some View {
        NavigationView{
            List {
                ForEach(menu, id: \.name) { section in  // Use name as ID
                    Text(section.name)
                    ForEach(section.items, id: \.name) { item in  // Use name as ID for MenuItem
                        Text(item.name)
                    }
                }

                }
            }
            .navigationTitle("Menu")
            .listStyle(.inset)
        }
    }

struct YourApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
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
            .environmentObject(authViewModel)
        }
    }
}
