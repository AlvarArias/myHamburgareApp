
import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = "My recipes"
    @StateObject private var recipeViewModel = RecipeViewModel()
    @Environment(\.dismiss) private var dismiss

    let tabs = ["My recipes", "Settings"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 16) {
                // Foto de usuario
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.accentColor, lineWidth: 3))
                    .padding(.top, 8)

                // Nombre y descripción
                Text("Jhon Per")
                    .font(.title2)
                    .bold()
                Text("burgar entusiast")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Tabs
                HStack(spacing: 24) {
                    ForEach(tabs, id: \ .self) { tab in
                        Button(action: { selectedTab = tab }) {
                            Text(tab)
                                .font(.headline)
                                .foregroundColor(selectedTab == tab ? .accentColor : .gray)
                                .underline(selectedTab == tab, color: .accentColor)
                        }
                    }
                }
                .padding(.vertical, 8)

                // Grid de recetas (solo si está seleccionado "My recipes")
                if selectedTab == "My recipes" {
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

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // back action
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
