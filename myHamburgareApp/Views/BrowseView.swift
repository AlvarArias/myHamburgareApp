
import SwiftUI

struct BrowseView: View {
    // Etiquetas
    let tags = ["Popular", "Vegetarian", "30 minutos", "Mis recetas"]
    @State private var selectedTag = "Popular"
    @State private var searchText = ""
    @StateObject private var recipeViewModel = RecipeViewModel()
    @EnvironmentObject var tabSelection: TabSelection

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                // Título y botón de ajustes
                /*
                HStack {
                   
                    Spacer()
                    Button(action: {
                        // Acción de ajustes de búsqueda
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal)
                */
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
                
                // Grid de recetas
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(recipeViewModel.recipes) { recipe in
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: "leaf")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)
                                    .foregroundColor(.green)
                                Text(recipe.name)
                                    .font(.headline)
                                Text(recipe.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
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
    }
}

#Preview {
    BrowseView()
}
