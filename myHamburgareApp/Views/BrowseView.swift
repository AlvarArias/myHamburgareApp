import SwiftUI

struct BrowseView: View {
    // Etiquetas
    let tags = ["Popular", "Vegetarian", "30 minutos", "Mis recetas"]
    @State private var selectedTag = "Popular"
    @State private var searchText = ""
    @EnvironmentObject private var recipeViewModel: RecipeViewModel
    @EnvironmentObject var tabSelection: TabSelection

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private var filteredRecipes: [Recipe] {
        recipeViewModel.recipes.filter { recipe in
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

    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                
                // Barra de búsqueda
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Buscar recetas...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Etiquetas horizontales
                etiquerasView
               
                // Grid de recetas
                recipesGridView
                    .padding(.top, 8)
                
            }
            .padding(.top)
            .navigationTitle("Browse")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        tabSelection.selectedTab = 0 // Cambia al tab Home
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
    BrowseView()
        .environmentObject(RecipeViewModel())
        .environmentObject(TabSelection())
}

extension BrowseView {
    var etiquerasView : some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(tags, id: \ .self) { tag in
                    Button(action: { selectedTag = tag }) {
                        Text(tag)
                            .font(.subheadline)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 16)
                            .background(selectedTag == tag ? Color.accentColor : Color(.systemGray5))
                            .foregroundColor(selectedTag == tag ? .white : .primary)
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
            if filteredRecipes.isEmpty {
                Text("No se encontraron recetas.")
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredRecipes) { recipe in
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
