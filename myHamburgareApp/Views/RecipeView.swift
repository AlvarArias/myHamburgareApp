import SwiftUI

struct RecipeView: View {
    let recipe: Recipe
    let rating: Double
    let ingredients: [String]
    let instructions: [String]

    @State private var checkedIngredients: [Bool]
    @State private var checkedInstructions: [Bool]
    @State private var userRating: Int = 0

    init(recipe: Recipe) {
        self.recipe = recipe
        self.rating = 4.5
        self.ingredients = recipe.ingredientes
        self.instructions = recipe.pasos
        self._checkedIngredients = State(initialValue: Array(repeating: false, count: recipe.ingredientes.count))
        self._checkedInstructions = State(initialValue: Array(repeating: false, count: recipe.pasos.count))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Recipe Header
                recipeHeader
                    .padding(.top, 8)
                
                // Recipe extra details
                recipeExtraDetails
                
                Divider()

                // Ingredientes
                ingredientsView
                
                Divider()
                
                // Instrucciones
                instructionsView
                
                Divider()
                
                // Botón
                Button(action: {
                    // Acción para agregar a la lista de compras
                }) {
                    Text("Add to shopping list")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                
                
                // Agregar review con estrellas
                addReviewView
                
                
            }
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

#Preview {
    RecipeView(recipe: Recipe(
        nombreReceta: "Hamburguesa Clásica",
        descripcion: "Una hamburguesa deliciosa con queso, lechuga y salsa especial.",
        categoria: .carne,
        tiempoEjecucion: 25,
        caloriasAproximadas: 720,
        imageName: nil,
        nivelDificultad: .facil,
        pasos: ["Cocinar la carne.", "Montar la hamburguesa.", "Servir caliente."],
        ingredientes: ["Carne", "Queso", "Pan", "Lechuga", "Tomate"],
        listaCompra: ["Carne", "Pan", "Queso", "Lechuga", "Tomate"]
    ))
}

extension RecipeView {
    
    var recipeHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Imagen principal
            Group {
                if let imageName = recipe.imageName,
                   !imageName.isEmpty,
                   UIImage(named: imageName) != nil {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                } else {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .overlay(
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                        )
                }
            }
            .frame(height: 220)
            .cornerRadius(16)
            .clipped()
            .padding(.horizontal)
            .padding(.top, 8)

            // Nombre y descripción
            Text(recipe.nombreReceta)
                .font(.title)
                .bold()
                .padding(.horizontal)

            Text(recipe.descripcion)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            HStack(spacing: 16) {
                Label(recipe.categoria.displayName, systemImage: "tag")
                Label(recipe.caloriesFormatted, systemImage: "flame")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.horizontal)
        }
    }
    
}

extension RecipeView {
    
    var recipeExtraDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Rating
            HStack(alignment: .center, spacing: 6) {
                Text(String(format: "%.1f", rating))
                    .font(.headline)
                HStack(spacing: 2) {
                    ForEach(0..<5) { i in
                        Image(systemName: i < Int(rating.rounded()) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
            }
            .padding(.horizontal)
            
            // Línea de tiempo y nivel
            HStack(spacing: 24) {
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .foregroundColor(.accentColor)
                    Text(recipe.executionTimeFormatted)
                        .font(.subheadline)
                }
                HStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.accentColor)
                    Text(recipe.nivelDificultad.displayName)
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
        }
    }
    
}

extension RecipeView {
    
    var ingredientsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients")
                .font(.headline)
            ForEach(0..<ingredients.count, id: \ .self) { i in
                HStack {
                    Image(systemName: checkedIngredients[i] ? "checkmark.square.fill" : "square")
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            checkedIngredients[i].toggle()
                        }
                    Text(ingredients[i])
                }
            }
        }
        .padding(.horizontal)
    }
    
}

extension RecipeView {
    
    var instructionsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Instructions")
                .font(.headline)
            ForEach(0..<instructions.count, id: \ .self) { i in
                HStack {
                    Image(systemName: checkedInstructions[i] ? "checkmark.square.fill" : "square")
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            checkedInstructions[i].toggle()
                        }
                    Text(instructions[i])
                }
            }
        }
        .padding(.horizontal)
    }
    
}


extension RecipeView {
    
    var addReviewView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Add a review")
                .font(.headline)
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { i in
                    Image(systemName: i <= userRating ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            userRating = i
                        }
                }
            }
        }
        .padding(.horizontal)
    }
    
}
