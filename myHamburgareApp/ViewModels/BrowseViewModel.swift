import Foundation
import Combine

@MainActor
final class BrowseViewModel: ObservableObject {
    let tags = ["Popular", "Vegetarian", "30 minutos", "Mis recetas"]
    @Published var searchText = ""
    @Published var selectedTag = "Popular"
    @Published private(set) var recipes: [Recipe] = []

    private let recipeStore: any RecipeStoreProviding
    private var cancellables = Set<AnyCancellable>()

    init(recipeStore: any RecipeStoreProviding) {
        self.recipeStore = recipeStore
        recipes = recipeStore.recipes
        bindStore()
    }

    private func bindStore() {
        recipeStore.objectWillChange
            .sink { [weak self] in
                guard let self = self else { return }
                self.recipes = self.recipeStore.recipes
            }
            .store(in: &cancellables)
    }

    var filteredRecipes: [Recipe] {
        recipes.filter { recipe in
            let matchesSearch = searchText.isEmpty ||
                recipe.nombreReceta.localizedCaseInsensitiveContains(searchText) ||
                recipe.descripcion.localizedCaseInsensitiveContains(searchText)

            guard matchesSearch else { return false }

            switch selectedTag {
            case "Popular":
                return true
            case "Vegetarian":
                return recipe.categoria == .vegana || recipe.categoria == .vegetariana
            case "30 minutos":
                return recipe.tiempoEjecucion <= 30
            case "Mis recetas":
                return true
            default:
                return true
            }
        }
    }
}
