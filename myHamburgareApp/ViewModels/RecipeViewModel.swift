import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    // Lista de recetas de ejemplo
    @Published var recipes: [Recipe] = [
        Recipe(id: 1, name: "Classic Burger", description: "Carne, queso, lechuga y tomate."),
        Recipe(id: 2, name: "Veggie Burger", description: "Hamburguesa vegetariana con garbanzos."),
        Recipe(id: 3, name: "BBQ Burger", description: "Con salsa barbacoa y cebolla caramelizada."),
        Recipe(id: 4, name: "Chicken Burger", description: "Pollo crujiente y mayonesa especial."),
        Recipe(id: 5, name: "Cheese Lover's Burger", description: "Extra queso cheddar y suizo.")
    ]
}

struct Recipe: Identifiable {
    let id: Int
    let name: String
    let description: String
}

