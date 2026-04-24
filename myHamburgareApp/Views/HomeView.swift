//
//  HomeView.swift
//  myHamburgareApp
//
//  Created by Alvar Arias on 2025-08-13.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Trending now")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                scrollView
                    .padding(.top, 0)

                featuredRecipes
                    .padding(.top, 0)
            }
            .navigationTitle("Burger App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Acción del botón de búsqueda
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .padding(.top, 10)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(recipeStore: RecipeStore(repository: JSONRecipeRepository(bundle: .main))))
}

// Search Bar View
extension HomeView {
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .frame(width: 50, height: 50)

            TextField("Buscar...", text: .constant(""))
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(8)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}

// Horizontal Scroll View
extension HomeView {
    var scrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.trendingRecipes) { recipe in
                    NavigationLink(destination: RecipeView(recipe: recipe)) {
                        VStack {
                            Image("Hamburgere")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .cornerRadius(8)

                            Text(recipe.nombreReceta)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: 150, minHeight: 60)
                                .lineLimit(3)
                                .truncationMode(.tail)
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
}

// Featured Recipes List
extension HomeView {
    var featuredRecipes: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Featured Recipes")
                .font(.title2)
                .bold()
                .padding(.horizontal)
                .foregroundColor(Color("Accento"))

            List(viewModel.featuredRecipes) { recipe in
                NavigationLink(destination: RecipeView(recipe: recipe)) {
                    HStack {
                        Image("Hamburgere")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.green)
                            .cornerRadius(8)

                        VStack(alignment: .leading) {
                            Text(recipe.nombreReceta)
                                .font(.headline)
                            Text(recipe.descripcion)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.plain)
            .frame(height: 300)
        }
        .background(Color("Background"))
    }
}
