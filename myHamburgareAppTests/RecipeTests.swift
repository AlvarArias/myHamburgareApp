import Foundation
import Combine
import Testing
@testable import myHamburgareApp

final class RecipeTestsBundleHolder {}

@MainActor
final class MockRecipeStore: ObservableObject, RecipeStoreProviding {
    @Published private(set) var recipes: [Recipe]

    init(recipes: [Recipe] = []) {
        self.recipes = recipes
    }

    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
    }
}

@MainActor
struct RecipeTests {
    private func makeRecipe(
        name: String,
        category: RecipeCategory,
        time: Int
    ) -> Recipe {
        Recipe(
            nombreReceta: name,
            descripcion: "Descripción de prueba",
            categoria: category,
            tiempoEjecucion: time,
            caloriasAproximadas: 250,
            imageName: nil,
            nivelDificultad: .facil,
            pasos: ["Paso 1", "Paso 2"],
            ingredientes: ["Ingrediente 1", "Ingrediente 2"],
            listaCompra: ["Ingrediente 1", "Ingrediente 2"]
        )
    }

    @Test func jsonRecipeRepositoryLoadsRecipes() async throws {
        let bundle = Bundle(for: RecipeTestsBundleHolder.self)
        let repository = JSONRecipeRepository(bundle: bundle)

        let recipes = try repository.loadRecipes()

        #expect(!recipes.isEmpty)
        #expect(recipes[0].nombreReceta == "Prueba Burger")
    }

    @Test func jsonRecipeRepositoryThrowsWhenFileMissing() async throws {
        let temporaryRoot = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("RecipeTestBundle_\(UUID().uuidString).bundle")
        try FileManager.default.createDirectory(at: temporaryRoot, withIntermediateDirectories: true)

        let infoPlist = temporaryRoot.appendingPathComponent("Info.plist")
        let plistContents = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>CFBundleIdentifier</key>
            <string>se.alvararias.myHamburgareAppTests</string>
        </dict>
        </plist>
        """
        try plistContents.write(to: infoPlist, atomically: true, encoding: .utf8)

        guard let missingBundle = Bundle(path: temporaryRoot.path) else {
            #expect(false)
            return
        }

        let repository = JSONRecipeRepository(bundle: missingBundle)
        do {
            _ = try repository.loadRecipes()
            #expect(false)
        } catch let error as RecipeRepositoryError {
            if case .fileNotFound = error {
                #expect(true)
            } else {
                #expect(false)
            }
        }
    }

    @Test func recipeStoreLoadsRecipesAndAddsRecipe() async throws {
        let firstRecipe = makeRecipe(name: "Receta A", category: .carne, time: 15)
        let store = await RecipeStore(repository: FakeRecipeRepository(recipes: [firstRecipe]))

        #expect(store.recipes.count == 1)

        let secondRecipe = makeRecipe(name: "Receta B", category: .vegana, time: 10)
        await store.addRecipe(secondRecipe)

        #expect(store.recipes.count == 2)
        #expect(store.recipes.contains { $0.nombreReceta == "Receta B" })
    }

    @Test func homeViewModelReflectsStoreUpdates() async throws {
        let store = await MockRecipeStore(recipes: [
            makeRecipe(name: "Receta A", category: .carne, time: 10),
            makeRecipe(name: "Receta B", category: .vegana, time: 25)
        ])
        let viewModel = await HomeViewModel(recipeStore: store)

        #expect(viewModel.featuredRecipes.count == 2)
        #expect(viewModel.trendingRecipes.count == 2)

        await store.addRecipe(makeRecipe(name: "Receta C", category: .vegetariana, time: 15))
        await Task.yield()

        #expect(viewModel.featuredRecipes.count == 3)
    }

    @Test func browseViewModelFiltersBySearchTextAndTag() async throws {
        let store = await MockRecipeStore(recipes: [
            makeRecipe(name: "Hamburguesa Vegana", category: .vegana, time: 20),
            makeRecipe(name: "Hamburguesa Clásica", category: .carne, time: 35),
            makeRecipe(name: "Ensalada Verde", category: .vegetariana, time: 15)
        ])
        let viewModel = await BrowseViewModel(recipeStore: store)

        await MainActor.run {
            viewModel.searchText = "Vegana"
            viewModel.selectedTag = "Popular"
        }

        #expect(viewModel.filteredRecipes.count == 1)
        #expect(viewModel.filteredRecipes.first?.categoria == .vegana)

        await MainActor.run {
            viewModel.searchText = ""
            viewModel.selectedTag = "Vegetarian"
        }

        #expect(viewModel.filteredRecipes.count == 2)

        await MainActor.run {
            viewModel.selectedTag = "30 minutos"
        }

        #expect(viewModel.filteredRecipes.count == 2)
    }
}

struct FakeRecipeRepository: RecipeRepository {
    let recipes: [Recipe]

    func loadRecipes() throws -> [Recipe] {
        recipes
    }
}
