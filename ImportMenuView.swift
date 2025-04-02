import SwiftUI

struct ImportMenuView: View {
    @Environment(\.dismiss) var dismiss
    @State private var menuData: [MenuSection] = []
    @State private var selectedCategory = "Breakfast"
    @State private var newItemName = ""
    @State private var newItemCalories = ""
    @State private var newItemDescription = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showClearConfirmation = false
    
    let categories = ["Breakfast", "Mains", "Lunch", "Dinner", "Desserts", "Bakery", "Grill"]
    let maroon = Color(red: 157/255, green: 34/255, blue: 53/255)
    let lightGray = Color.gray.opacity(0.2)
    
    var body: some View {
        Group {
#if os(macOS)
            mainContent
#else
            NavigationView {
                mainContent
                    .navigationBarTitle("", displayMode: .inline)
            }
#endif
        }
        .alert("Success", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .confirmationDialog(
            "Clear Menu",
            isPresented: $showClearConfirmation,
            actions: {
                Button("Clear Entire Menu", role: .destructive) { clearMenu() }
                Button("Cancel", role: .cancel) {}
            },
            message: {
                Text("This will permanently delete all menu items. Continue?")
            }
        )
        .onAppear(perform: loadMenuData)
    }
    
    private var mainContent: some View {
        ZStack {
            maroon.ignoresSafeArea()
            VStack(spacing: 0) {
#if os(macOS)
                Text("Menu Management")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
#else
                header
#endif
                
                formContent
                
                Button(action: { dismiss() }) {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(maroon)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
    }
    
    // ... [keep all your existing methods and subviews exactly the same] ...
    private var header: some View {
        Text("Menu Management")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 20)
    }
    
    private var formContent: some View {
        Form {
            categorySection
            itemDetailsSection
            actionButtonsSection
        }
        .scrollContentBackground(.hidden)
        .background(maroon)
    }
    
    private var categorySection: some View {
        Section(header: sectionHeader("SELECT CATEGORY")) {
            Picker("Menu Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .tag(category as String)
                }
            }
            .pickerStyle(.menu)
            .accentColor(maroon)
        }
        .listRowBackground(lightGray)
    }
    
    private var itemDetailsSection: some View {
        Section(header: sectionHeader("ITEM DETAILS")) {
            CustomTextField("Item Name", text: $newItemName)
            CustomTextField("Calories (optional)", text: $newItemCalories)
            CustomTextField("Description (optional)", text: $newItemDescription)
        }
        .listRowBackground(lightGray)
    }
    
    private var actionButtonsSection: some View {
        Section {
            HStack {
                Button(action: addNewItem) {
                    Text("Add Item")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(newItemName.isEmpty)
                
                Button(action: { showClearConfirmation = true }) {
                    Text("Clear Menu")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            
            Button(action: saveMenuToFile) {
                Text("Save All Changes")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(maroon)
        }
        .listRowBackground(Color.clear)
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .foregroundColor(.white)
            .font(.caption)
    }
    
    // MARK: - Data Methods
    private func loadMenuData() {
        let url = getMenuFileURL()
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let loadedData = try decoder.decode([MenuSection].self, from: data)
            self.menuData = loadedData
        } catch {
            print("Load failed: \(error)")
            // Initialize with empty categories if file doesn't exist or is invalid
            self.menuData = categories.map {
                MenuSection(id: UUID(), name: $0, items: [])
            }
        }
    }
    
    private func addNewItem() {
        // Format the description properly
        var description = ""
        
        if !newItemCalories.isEmpty {
            // Ensure calories format is consistent (e.g., "200 cal")
            let caloriesText = newItemCalories.lowercased().contains("cal") ?
                newItemCalories :
                "\(newItemCalories) cal"
            description = caloriesText
        }
        
        if !newItemDescription.isEmpty {
            description = description.isEmpty ?
                newItemDescription :
                "\(description) - \(newItemDescription)"
        }
        
        let newItem = MenuItem(
            id: UUID(),
            name: newItemName.trimmingCharacters(in: .whitespaces),
            description: description
        )
        
        // Find or create the category
        if let index = menuData.firstIndex(where: { $0.name == selectedCategory }) {
            menuData[index].items.append(newItem)
        } else {
            menuData.append(MenuSection(
                id: UUID(),
                name: selectedCategory,
                items: [newItem]
            ))
        }
        
        saveMenuToFile()
        resetFields()
        
        alertMessage = "\(newItemName) added to \(selectedCategory)"
        showingAlert = true
    }
    
    private func resetFields() {
        newItemName = ""
        newItemCalories = ""
        newItemDescription = ""
    }
    
    private func saveMenuToFile() {
        let url = getMenuFileURL()
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys] // Add sortedKeys
            let data = try encoder.encode(menuData)
            try data.write(to: url)
            print("💾 Saved to: \(url.path)")
            DispatchQueue.main.async {
                self.loadMenuData()
            }
        } catch {
            print("🔴 Save failed: \(error)")
        }
    }
    
    private func clearMenu() {
        menuData = categories.map {
            MenuSection(id: UUID(), name: $0, items: [])
        }
        saveMenuToFile()
        alertMessage = "Menu has been cleared"
        showingAlert = true
    }
    
    private func getMenuFileURL() -> URL {
        let hardcodedPath = "/Users/ireneichwan/Desktop/ChapmanChow/ChapmanChow/menu.json"
        return URL(fileURLWithPath: hardcodedPath)
    }
    
    struct CustomTextField: View {
        let title: String
        @Binding var text: String
        
        init(_ title: String, text: Binding<String>) {
            self.title = title
            self._text = text
        }
        
        var body: some View {
            TextField(title, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    struct ImportMenuView_Previews: PreviewProvider {
        static var previews: some View {
            ImportMenuView()
        }
        
        struct MenuSection: Codable, Identifiable {
            let name: String
            let items: [MenuItem]
            let id: UUID
            
            init(id: UUID = UUID(), name: String, items: [MenuItem]) {
                self.name = name
                self.items = items
                self.id = id
            }
        }
        
        struct MenuItem: Codable, Identifiable {
            let name: String
            let description: String
            let id: UUID  // Move id last
            
            // If you need to maintain backward compatibility with existing code
            // that might expect id first, keep this initializer:
            init(id: UUID = UUID(), name: String, description: String) {
                self.name = name
                self.description = description
                self.id = id
            }
        }
    }
    
}
