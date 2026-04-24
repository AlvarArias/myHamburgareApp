import Foundation
import Combine

enum RecipeRepositoryError: Error, LocalizedError {
    case fileNotFound(String)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let resource):
            return "No se encontró el recurso \(resource)."
        case .decodingFailed(let error):
            return "Error al decodificar recetas: \(error.localizedDescription)"
        }
    }
}

protocol RecipeRepository {
    func loadRecipes() throws -> [Recipe]
}

@MainActor
protocol RecipeStoreProviding: ObservableObject {
    var objectWillChange: ObservableObjectPublisher { get }
    var recipes: [Recipe] { get }
    func addRecipe(_ recipe: Recipe)
}

final class JSONRecipeRepository: RecipeRepository {
    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func loadRecipes() throws -> [Recipe] {
        guard let url = bundle.url(forResource: "Recetas", withExtension: "json") else {
            throw RecipeRepositoryError.fileNotFound("Recetas.json")
        }

        let data = try Data(contentsOf: url)
        do {
            return try JSONDecoder().decode([Recipe].self, from: data)
        } catch {
            throw RecipeRepositoryError.decodingFailed(error)
        }
    }
}

@MainActor
final class RecipeStore: ObservableObject, RecipeStoreProviding {
    @Published private(set) var recipes: [Recipe] = []

    private let repository: RecipeRepository

    init(repository: RecipeRepository = JSONRecipeRepository()) {
        self.repository = repository
        loadRecipes()
    }

    private func loadRecipes() {
        do {
            recipes = try repository.loadRecipes()
            print("Recetas cargadas exitosamente: \(recipes.count)")
        } catch {
            print("Error al cargar las recetas: \(error)")
        }
    }

    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
    }
}

