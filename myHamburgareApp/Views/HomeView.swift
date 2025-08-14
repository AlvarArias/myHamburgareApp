//
//  HomeView.swift
//  myHamburgareApp
//
//  Created by Alvar Arias on 2025-08-13.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Encabezado superior
            VStack(spacing: 10) {
              
                searchBar
                    .padding(.horizontal)
                  
                HStack {
                    Spacer()
                    Text("Burger App")
                        .font(.title)
                        .bold()
                    Spacer()
                }
            }

            Text("Trending now")
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            //Horizontal List View
            scrollView
                .padding(.top, 0)

            // Featured Recipes List
            featuredRecipes
                .padding(.top, 10)

        }
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
        
            // Trending Now - Horizontal List View
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
            List(0..<5, id: \.self) { index in
                HStack {
                    Image(systemName: "leaf")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("Recipe \(index + 1)")
                            .font(.headline)
                        Text("Descripción breve de la receta.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
            .frame(height: 300)
        }
    }
    
}
