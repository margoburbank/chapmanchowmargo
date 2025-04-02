import SwiftUI

struct MenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var sections: [MenuSection]? // Optional parameter for pre-loaded sections
    @State private var loadedSections: [MenuSection] = []
    
    // Determine which sections to display
    var displaySections: [MenuSection] {
        sections ?? loadedSections // Use passed sections if available, otherwise loaded ones
    }
    
    var body: some View {
        ZStack {
            // Chapman red background
            Color(red: 157/255, green: 34/255, blue: 53/255)
                .ignoresSafeArea()
            
            List {
                ForEach(displaySections) { section in
                    Section(header: Text(section.name)
                        .foregroundColor(.white)
                        .font(.headline)) {
                            ForEach(section.items, id: \.id) { item in
                                MenuItemView(item: item)
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Menu")
        .onAppear {
            if sections == nil { // Only load data if no sections were provided
                loadMenuData()
            }
            printMenuData()
        }
    }
    
    private func loadMenuData() {
        // 1. First try loading from JSON
        if let jsonData = loadFromJSON() {
            loadedSections = jsonData
            print("✅ Loaded from JSON")
        }
        // 2. If JSON fails, use preview data
        else {
            loadedSections = previewMenuData()
            print("⚠️ Using preview data")
        }
    }
    
    private func printMenuData() {
        print("=== MENU DATA ===")
        displaySections.forEach { section in
            print("Section: \(section.name)")
            section.items.forEach { item in
                print(" - \(item.name) | \(item.description)")
            }
        }
    }
    
    private func loadFromJSON() -> [MenuSection]? {
        let url = URL(fileURLWithPath: "/Users/ireneichwan/Desktop/ChapmanChow/ChapmanChow/menu.json")
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let sections = try decoder.decode([MenuSection].self, from: data)
            return sections
        } catch {
            print("❌ JSON Error: \(error)")
            return nil
        }
    }
    
    private func previewMenuData() -> [MenuSection] {
        return [
            MenuSection(
                id: UUID(),
                name: "Breakfast",
                items: [
                    MenuItem(
                        id: UUID(),
                        name: "Cage Free Scrambled Eggs",
                        description: "180 cal - Fresh cage-free eggs scrambled to perfection"
                    ),
                    MenuItem(
                        id: UUID(),
                        name: "Croissant",
                        description: "200 cal - Buttery and flaky"
                    )
                ]
            ),
            MenuSection(
                id: UUID(),
                name: "Mains",
                items: [
                    MenuItem(
                        id: UUID(),
                        name: "Penne Pasta With Grilled Sausage",
                        description: "490 cal - Hearty pasta with grilled sausage"
                    )
                ]
            )
        ]
    }
}

// Updated Preview Provider with both initialization methods
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with self-loaded data
            NavigationStack {
                MenuView()
                    .environmentObject(AuthViewModel())
            }
            
            // Preview with passed-in sections
            NavigationStack {
                MenuView(sections: [
                    MenuSection(
                        id: UUID(),
                        name: "Preview Section",
                        items: [
                            MenuItem(
                                id: UUID(),
                                name: "Preview Item",
                                description: "Preview description"
                            )
                        ]
                    )
                ])
                .environmentObject(AuthViewModel())
            }
        }
    }
}
