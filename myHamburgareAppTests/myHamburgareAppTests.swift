import Testing
@testable import myHamburgareApp

struct myHamburgareAppTests {

    @Test func recipeComputedProperties() {
        let recipe = Recipe(
            nombreReceta: "Test Burger",
            descripcion: "Desc",
            categoria: .carne,
            tiempoEjecucion: 30,
            caloriasAproximadas: 500,
            imageName: nil,
            nivelDificultad: .facil,
            pasos: ["Step 1", "Step 2"],
            ingredientes: ["Item 1"],
            listaCompra: ["Item 1"]
        )
        #expect(recipe.executionTimeFormatted == "30 min")
        #expect(recipe.caloriesFormatted == "500 cal")
        #expect(recipe.stepCount == 2)
        #expect(recipe.ingredientCount == 1)
    }

}
