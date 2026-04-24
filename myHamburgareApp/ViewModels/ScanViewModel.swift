import Foundation
import Combine

@MainActor
final class ScanViewModel: ObservableObject {
    @Published private(set) var scannedRecipe: Recipe?
    @Published var scanErrorMessage: String?

    private let recipeStore: any RecipeStoreProviding
    private var cancellables = Set<AnyCancellable>()

    init(recipeStore: any RecipeStoreProviding) {
        self.recipeStore = recipeStore
        bindStore()
    }

    private func bindStore() {
        recipeStore.objectWillChange
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    var isRecipeSaved: Bool {
        guard let recipe = scannedRecipe else { return false }
        return recipeStore.recipes.contains { storedRecipe in
            storedRecipe.nombreReceta == recipe.nombreReceta &&
            storedRecipe.descripcion == recipe.descripcion
        }
    }

    func handleScanResult(_ result: Result<String, Error>) {
        switch result {
        case .success(let scannedText):
            do {
                let recipe = try Recipe.from(scannedString: scannedText)
                scannedRecipe = recipe
                scanErrorMessage = nil
            } catch {
                scannedRecipe = nil
                scanErrorMessage = "No se pudo convertir el código QR en una receta válida."
            }
        case .failure:
            scannedRecipe = nil
            scanErrorMessage = "No se detectó ningún QR válido. Por favor inténtalo de nuevo."
        }
    }

    func saveScannedRecipe() {
        guard let recipe = scannedRecipe else {
            scanErrorMessage = "No hay receta para guardar."
            return
        }

        guard !isRecipeSaved else {
            scanErrorMessage = "La receta ya está guardada."
            return
        }

        recipeStore.addRecipe(recipe)
        scanErrorMessage = "Receta guardada correctamente."
    }
}
