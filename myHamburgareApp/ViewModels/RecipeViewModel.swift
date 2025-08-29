import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    // Lista de recetas cargadas desde el archivo JSON
    @Published var recipes: [Recipe] = []

    init() {
        loadRecipes()
    }

    private func loadRecipes() {
        guard let url = Bundle.main.url(forResource: "Recetas", withExtension: "json") else {
            print("Error: No se encontró el archivo Recetas.json")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            recipes = try decoder.decode([Recipe].self, from: data)
            print("Recetas cargadas exitosamente: \(recipes.count)")
        } catch {
            print("Error al cargar las recetas: \(error)")
        }
    }
}

