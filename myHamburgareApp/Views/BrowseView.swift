import SwiftUI

struct BrowseView: View {
    @StateObject private var viewModel: BrowseViewModel
    @EnvironmentObject var tabSelection: TabSelection

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(viewModel: BrowseViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Buscar recetas...", text: $viewModel.searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                etiquerasView

                recipesGridView
                    .padding(.top, 8)
            }
            .padding(.top)
            .navigationTitle("Browse")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        tabSelection.selectedTab = 0
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Acción de ajustes de búsqueda
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    BrowseView(viewModel: BrowseViewModel(recipeStore: RecipeStore(repository: JSONRecipeRepository(bundle: .main))))
        .environmentObject(TabSelection())
}

extension BrowseView {
    var etiquerasView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.tags, id: \ .self) { tag in
                    Button(action: { viewModel.selectedTag = tag }) {
                        Text(tag)
                            .font(.subheadline)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 16)
                            .background(viewModel.selectedTag == tag ? Color.accentColor : Color(.systemGray5))
                            .foregroundColor(viewModel.selectedTag == tag ? .white : .primary)
                            .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

extension BrowseView {
    var recipesGridView: some View {
        ScrollView {
            if viewModel.filteredRecipes.isEmpty {
                Text("No se encontraron recetas.")
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.filteredRecipes) { recipe in
                        NavigationLink(destination: RecipeView(recipe: recipe)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: "leaf")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)
                                    .foregroundColor(.green)
                                Text(recipe.nombreReceta)
                                    .font(.headline)
                                Text(recipe.descripcion)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
