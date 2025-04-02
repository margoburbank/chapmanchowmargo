//
//  MenuDataLoader.swift
//  ChapmanChow
//
//  Created by Irene Ichwan on 4/2/25.
//


import Foundation

class MenuDataLoader {
    static let shared = MenuDataLoader()
    private let menuURL = URL(fileURLWithPath: "/Users/ireneichwan/Desktop/ChapmanChow/ChapmanChow/menu.json")
    
    func loadMenu() -> [MenuSection] {
        do {
            let data = try Data(contentsOf: menuURL)
            let decoder = JSONDecoder()
            let menu = try decoder.decode([MenuSection].self, from: data)
            
            // Debug print
            print("Loaded menu sections:")
            menu.forEach { section in
                print("🍽 \(section.name) (\(section.items.count) items)")
                section.items.forEach { item in
                    print("   - \(item.name)")
                }
            }
            
            return menu
        } catch {
            print("Failed to load menu: \(error)")
            return [] // Return empty array if fails
        }
    }
}
