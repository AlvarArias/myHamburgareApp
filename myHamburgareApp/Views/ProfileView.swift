import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var selectedTab = "My recipes"
    @EnvironmentObject var tabSelection: TabSelection

    @AppStorage("profileName") private var profileName = "Jhon Per"
    @AppStorage("profileBio") private var profileBio = "burger enthusiast"
    @AppStorage("profileNotificationsEnabled") private var notificationsEnabled = true
    @AppStorage("profileFavoriteTag") private var favoriteTag = "Popular"

    let tabs = ["My recipes", "Settings"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 16) {
                userDetail

                tabSelector

                if selectedTab == "My recipes" {
                    myRecipesGrid
                } else {
                    settingsView
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Profile")
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
            }
        }
    }

    private var tabSelector: some View {
        HStack(spacing: 24) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    Text(tab)
                        .font(.headline)
                        .foregroundColor(selectedTab == tab ? .accentColor : .gray)
                        .underline(selectedTab == tab, color: .accentColor)
                }
            }
        }
        .padding(.vertical, 8)
    }

    private var settingsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Perfil")
                    .font(.headline)

                TextField("Nombre", text: $profileName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Bio", text: $profileBio)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Toggle("Recibir notificaciones", isOn: $notificationsEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))

                Picker("Etiqueta favorita", selection: $favoriteTag) {
                    ForEach(["Popular", "Vegetarian", "30 minutos", "Mis recetas"], id: \.self) { tag in
                        Text(tag)
                    }
                }
                .pickerStyle(.menu)

                Text("Los ajustes se guardan automáticamente.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }

    private var userDetail: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.accentColor, lineWidth: 3))
                .padding(.top, 8)

            Text(profileName)
                .font(.title2)
                .bold()
            Text(profileBio)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.bottom, 8)
    }

    private var myRecipesGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.recipes) { recipe in
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
            .padding(.horizontal)
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(recipeStore: RecipeStore(repository: JSONRecipeRepository(bundle: .main))))
        .environmentObject(TabSelection())
}

