//
//  HomeView.swift
//  myHamburgareApp
//
//  Created by Alvar Arias on 2025-08-13.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
            
                // Horizontal Scroll View
                Text("Trending now")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                
                //Horizontal List View
                scrollView
                    .padding(.top, 0)
                
                // Featured Recipes List
                featuredRecipes
                    .padding(.top, 10)
                
            }
            .navigationTitle("Burger App")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                // Acción del botón de búsqueda
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
            })
            .padding(.top, 10)
            .background(Color(.blue))
        }
        .background(Color(.systemBackground))
        
    }
        
}

#Preview {
    HomeView()
}


extension HomeView {
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Buscar...", text: .constant(""))
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
    
}


extension HomeView {
    
    var scrollView: some View {
        
            ScrollView(.horizontal, showsIndicators: false) {
               
                HStack(spacing: 16) {
                    ForEach(0..<10) { index in
                        VStack {
                            Image(systemName: "flame.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.accentColor)
                            Text("Item \(index + 1)")
                                .font(.caption)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding()
                }
                .padding(. horizontal)
                
            }
            .background(Color.red)

          
        }
    
}

extension HomeView {
    
    var featuredRecipes: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Featured Recipes")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            List(recipeViewModel.recipes) { recipe in
                HStack {
                    Image(systemName: "leaf")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.headline)
                        Text(recipe.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
            .frame(height: 300)
        }
        .background(Color(.systemBackground))
    }
    
}
