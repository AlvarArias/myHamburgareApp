import SwiftUI

struct RecipeView: View {
    // Datos de ejemplo
    let recipeName: String = "Classic Burger"
    let recipeDescription: String = "Delicious burger with cheese, lettuce, tomato, and special sauce."
    let rating: Double = 4.5
    let ingredients = [
        "Beef Patty", "Cheddar Cheese", "Lettuce", "Tomato", "Onion", "Burger Bun"
    ]
    let instructions = [
        "Grill the beef patty.",
        "Toast the bun.",
        "Assemble the burger with cheese and veggies.",
        "Add sauce and serve."
    ]
    
    @State private var checkedIngredients = Array(repeating: false, count: 6)
    @State private var checkedInstructions = Array(repeating: false, count: 4)
    @State private var userRating: Int = 0
    
    var body: some View {
        NavigationView {
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Acción de volver
                    }) {
                        Image(systemName: "chevron.left")
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
    RecipeView()
}

extension RecipeView {
    
    var recipeHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Imagen principal
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 220)
                .overlay(
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                )
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.top, 8)
            // Nombre y descripción
            Text(recipeName)
                .font(.title)
                .bold()
                .padding(.horizontal)
            Text(recipeDescription)
                .font(.body)
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
                    Text("15 min")
                        .font(.subheadline)
                }
                HStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.accentColor)
                    Text("easy")
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
