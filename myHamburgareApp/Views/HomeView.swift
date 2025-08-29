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
                    .padding(.top, 0)
                
            }
            .navigationTitle("Burger App")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                // Acción del botón de búsqueda
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.accentColor)
            })
            .padding(.top, 10)
            //.background(Color(.blue).opacity(0.15))
        }
        .background(Color(.systemBackground))
    
       
    }
        
}

#Preview {
    HomeView()
}

// Search Bar View
extension HomeView {
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                //.renderingMode(.template)
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
                    ForEach(0..<10) { index in
                        VStack {
                            Image("Hamburgere")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .cornerRadius(8)
                        
                            Text(recipeViewModel.recipes.randomElement()?.nombreReceta ?? "Recipe")
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
                    .padding()
                }
                .padding(. horizontal)
                
            }
           // .background(Color.red).opacity(0.5)

          
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
            
            List(recipeViewModel.recipes) { recipe in
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
            .listStyle(.plain)
            .frame(height: 300)
        }
        .background(Color("Background"))
    }
    
}
