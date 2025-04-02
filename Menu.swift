import SwiftUI

struct MenuSection: Codable, Identifiable {
    var id: UUID
    var name: String
    var items: [MenuItem]
}

struct MenuItem: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var description: String  // Now includes calories (e.g., "180 cal - Scrambled eggs")
}

#if DEBUG
extension MenuItem {
    static let example = MenuItem(
        id: UUID(),
        name: "Cage Free Scrambled Eggs",
        description: "180 cal - Fresh cage-free eggs scrambled to perfection"
    )
}
#endif
