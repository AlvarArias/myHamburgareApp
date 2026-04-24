import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
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
}
