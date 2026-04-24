import Foundation

// MARK: - Recipe Category Enum
enum RecipeCategory: String, CaseIterable, Codable {
    case carne = "carne"
    case vegana = "vegana"
    case vegetariana = "vegetariana"
    
    var displayName: String {
        switch self {
        case .carne:
            return "Carne"
        case .vegana:
            return "Vegana"
        case .vegetariana:
            return "Vegetariana"
        }
    }
}

// MARK: - Difficulty Level Enum
enum DifficultyLevel: String, CaseIterable, Codable {
    case facil = "fácil"
    case medio = "medio"
    case dificil = "difícil"
    
    var displayName: String {
        switch self {
        case .facil:
            return "Fácil"
        case .medio:
            return "Medio"
        case .dificil:
            return "Difícil"
        }
    }
}

// MARK: - Recipe Model
struct Recipe: Codable, Identifiable {
    let id = UUID() // Unique identifier for each recipe
    var nombreReceta: String
    let descripcion: String
    let categoria: RecipeCategory
    let tiempoEjecucion: Int // in minutes
    let caloriasAproximadas: Int
    let imageName: String?
    let nivelDificultad: DifficultyLevel
    let pasos: [String]
    let ingredientes: [String]
    let listaCompra: [String]
    
    // Custom coding keys to match JSON structure
    enum CodingKeys: String, CodingKey {
        case nombreReceta = "nombre_receta"
        case descripcion
        case categoria
        case tiempoEjecucion = "tiempo_ejecucion"
        case caloriasAproximadas = "calorias_aproximadas"
        case nivelDificultad = "nivel_dificultad"
        case pasos
        case ingredientes
        case listaCompra = "lista_compra"
        case imageName = "image_name"
    }

    static func from(scannedString: String) throws -> Recipe {
        let decoder = JSONDecoder()
        let data = scannedString.data(using: .utf8) ?? Data()
        if let recipe = try? decoder.decode(Recipe.self, from: data) {
            return recipe
        }
        if let array = try? decoder.decode([Recipe].self, from: data), let first = array.first {
            return first
        }
        throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "No se pudo decodificar la receta del texto escaneado."))
    }
    
    // Computed properties for display
    var executionTimeFormatted: String {
        return "\(tiempoEjecucion) min"
    }
    
    var caloriesFormatted: String {
        return "\(caloriasAproximadas) cal"
    }
    
    var ingredientCount: Int {
        return ingredientes.count
    }
    
    var stepCount: Int {
        return pasos.count
    }
}

// MARK: - Recipe Collection
struct RecipeCollection: Codable {
    let recipes: [Recipe]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        recipes = try container.decode([Recipe].self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(recipes)
    }
    
    // Convenience methods
    func recipesByCategory(_ category: RecipeCategory) -> [Recipe] {
        return recipes.filter { $0.categoria == category }
    }
    
    func recipesByDifficulty(_ difficulty: DifficultyLevel) -> [Recipe] {
        return recipes.filter { $0.nivelDificultad == difficulty }
    }
    
    func recipesWithMaxTime(_ maxMinutes: Int) -> [Recipe] {
        return recipes.filter { $0.tiempoEjecucion <= maxMinutes }
    }
    
    func recipesWithMaxCalories(_ maxCalories: Int) -> [Recipe] {
        return recipes.filter { $0.caloriasAproximadas <= maxCalories }
    }
}

// MARK: - Usage Example
class RecipeManager {
    private var recipeCollection: RecipeCollection?
    
    func loadRecipes(from jsonData: Data) {
        do {
            recipeCollection = try JSONDecoder().decode(RecipeCollection.self, from: jsonData)
            print("Successfully loaded \(recipeCollection?.recipes.count ?? 0) recipes")
        } catch {
            print("Error decoding recipes: \(error)")
        }
    }
    
    func loadRecipes(from jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            print("Error converting string to data")
            return
        }
        loadRecipes(from: data)
    }
    
    func getAllRecipes() -> [Recipe] {
        return recipeCollection?.recipes ?? []
    }
    
    func searchRecipes(by name: String) -> [Recipe] {
        return getAllRecipes().filter { 
            $0.nombreReceta.lowercased().contains(name.lowercased())
        }
    }
    
    func getRecipe(by index: Int) -> Recipe? {
        let recipes = getAllRecipes()
        guard index >= 0 && index < recipes.count else { return nil }
        return recipes[index]
    }
}

// MARK: - Example Usage
/*
let jsonString = """
[
  {
    "nombre_receta": "Hamburguesa Clásica con Queso",
    "descripcion": "Una deliciosa hamburguesa de carne jugosa con queso cheddar...",
    "categoria": "carne",
    "tiempo_ejecucion": 25,
    "calorias_aproximadas": 700,
    "nivel_dificultad": "fácil",
    "pasos": [...],
    "ingredientes": [...],
    "lista_compra": [...]
  }
]
"""

let manager = RecipeManager()
manager.loadRecipes(from: jsonString)
let recipes = manager.getAllRecipes()
*/
