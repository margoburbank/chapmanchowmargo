//
//  StaffHomeView.swift
//  ChapmanChow
//
//  Created by Irene Ichwan on 4/1/25.
//

import SwiftUI

struct StaffHomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var activeDestination: Destination?
    
    enum Destination {
        case importMenu
        case seeRequests
        case logWaste
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 157/255, green: 34/255, blue: 53/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Staff Portal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        HomeButton(
                            title: "Import Menu Items",
                            color: .white,
                            textColor: Color(red: 157/255, green: 34/255, blue: 53/255),
                            action: { activeDestination = .importMenu }
                        )
                        
                        HomeButton(
                            title: "See Meal Requests",
                            color: .white,
                            textColor: Color(red: 157/255, green: 34/255, blue: 53/255),
                            action: { activeDestination = .seeRequests }
                        )
                        
                        HomeButton(
                            title: "Log Food Waste",
                            color: .white,
                            textColor: Color(red: 157/255, green: 34/255, blue: 53/255),
                            action: { activeDestination = .logWaste }
                        )
                    }
                    .padding(.bottom, 50)
                    
                    Spacer()
                }
            }
            .navigationDestination(item: $activeDestination) { destination in
                switch destination {
                case .importMenu:
                    ImportMenuView()
                case .seeRequests:
                    SeeMealRequestsView()
                case .logWaste:
                    LogWasteView()
                }
            }
            
                
            
        }
    }
}
