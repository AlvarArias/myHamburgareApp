# Tests — Revisión y correcciones

## Archivos de test

| Archivo | Propósito |
|---|---|
| `myHamburgareAppTests.swift` | Pruebas unitarias del modelo `Recipe` |
| `RecipeTests.swift` | Pruebas de repositorio, store y view models |
| `Recetas.json` | Fixture de datos para el test de carga JSON |

---

## Función de cada test

### `myHamburgareAppTests.swift`

#### `recipeComputedProperties`
Verifica que las propiedades calculadas de `Recipe` devuelvan el formato correcto:
- `executionTimeFormatted` → `"30 min"`
- `caloriesFormatted` → `"500 cal"`
- `stepCount` y `ingredientCount` reflejan los arrays reales

---

### `RecipeTests.swift`

#### `jsonRecipeRepositoryLoadsRecipes`
Carga `Recetas.json` del bundle de test usando `JSONRecipeRepository` y verifica que:
- Se devuelvan recetas (array no vacío)
- La primera receta se llame `"Prueba Burger"` (el fixture de test, no producción)

#### `jsonRecipeRepositoryThrowsWhenFileMissing`
Crea un bundle temporal vacío (sin `Recetas.json`) y verifica que `loadRecipes()` lance exactamente el error `RecipeRepositoryError.fileNotFound`.

#### `recipeStoreLoadsRecipesAndAddsRecipe`
Usa `FakeRecipeRepository` para inyectar datos controlados en `RecipeStore` y verifica:
- El store inicializa con las recetas del repositorio
- `addRecipe()` incrementa el conteo y la receta queda accesible por nombre

#### `homeViewModelReflectsStoreUpdates`
Verifica que `HomeViewModel` refleje dinámicamente los cambios del store:
- `featuredRecipes` y `trendingRecipes` devuelven todos los elementos al inicio
- Al agregar una receta nueva al store, `featuredRecipes` se actualiza automáticamente

#### `browseViewModelFiltersBySearchTextAndTag`
Verifica los tres modos de filtrado de `BrowseViewModel.filteredRecipes`:
- Búsqueda por texto parcial + tag `"Popular"` → 1 resultado
- Tag `"Vegetarian"` (vegana + vegetariana) con texto vacío → 2 resultados
- Tag `"30 minutos"` (tiempo ≤ 30 min) → 2 resultados

---

## Problemas encontrados y correcciones

### 1. `myHamburgareAppTests.swift` — test vacío
**Problema:** El archivo contenía solo el template de Xcode con `example()` sin ninguna aserción. Compilaba y pasaba sin verificar nada.

**Corrección:** Reemplazado por `recipeComputedProperties()` con `#expect` reales sobre el modelo `Recipe`.

---

### 2. `RecipeTests.swift` — patrón de fallo incorrecto en `jsonRecipeRepositoryThrowsWhenFileMissing`
**Problema:** Se usaba `#expect(false)` para señalar fallos y `#expect(true)` dentro del catch correcto. El `#expect(true)` es un no-op (no aporta nada), y `#expect(false)` en una guarda de bundle nulo no comunica por qué falló.

**Corrección:** Reemplazados por `Issue.record("mensaje descriptivo")`, el idioma estándar de Swift Testing para fallos explícitos con contexto.

---

### 3. Bug de timing en `HomeViewModel` y `BrowseViewModel` (bug crítico)
**Problema:** Ambos view models suscribían a `objectWillChange` del store para actualizar `recipes`:

```swift
// ANTES — lee valor ANTES de que cambie
recipeStore.objectWillChange
    .sink { [weak self] in
        self?.recipes = self?.recipeStore.recipes ?? []
    }
```

`objectWillChange` es un publisher `willSet`: se dispara **antes** de que `@Published` escriba el nuevo valor. El sink leía el array antiguo, así que el view model siempre tenía datos desactualizados. El test `homeViewModelReflectsStoreUpdates` fallaba invariablemente en `#expect(count == 3)`.

**Corrección en el protocolo** (`RecipeViewModel.swift`):
```swift
protocol RecipeStoreProviding: ObservableObject {
    var recipesPublisher: AnyPublisher<[Recipe], Never> { get }  // añadido
    // ...
}
```

**Corrección en `RecipeStore`:**
```swift
var recipesPublisher: AnyPublisher<[Recipe], Never> {
    $recipes.eraseToAnyPublisher()  // publica DESPUÉS del cambio
}
```

**Corrección en los view models:**
```swift
// DESPUÉS — recibe el valor nuevo directamente
recipeStore.recipesPublisher
    .sink { [weak self] recipes in
        self?.recipes = recipes
    }
```

**Corrección en `MockRecipeStore`** (test): añadido `recipesPublisher` para conformar al protocolo actualizado.

**Corrección en el test:** eliminado `await Task.yield()` innecesario — con `recipesPublisher` el sink Combine ya es síncrono y el valor está actualizado en la misma llamada.

---

## Lo aprendido

### `objectWillChange` vs `$property` en Combine

| Publisher | Momento de disparo | Valor disponible |
|---|---|---|
| `objectWillChange` | `willSet` — antes del cambio | Valor **antiguo** |
| `$propiedad` | `didSet` — después del cambio | Valor **nuevo** |

Suscribirse a `objectWillChange` para leer datos del store es un patrón incorrecto: siempre devuelve el estado previo. El patrón correcto es exponer un `AnyPublisher` derivado de `$propiedad`.

### Protocolos con `@Published`

Swift no permite declarar `@Published var x` en un protocolo directamente. La solución es exponer el publisher mediante una propiedad adicional:

```swift
protocol RecipeStoreProviding {
    var recipes: [Recipe] { get }
    var recipesPublisher: AnyPublisher<[Recipe], Never> { get }
}
```

Esto mantiene la abstracción limpia y permite que mocks y stores concretos implementen el publisher de la forma que prefieran.

### `Issue.record()` vs `#expect(false)`

En Swift Testing, `Issue.record("mensaje")` es la forma idiomática de registrar un fallo con contexto descriptivo dentro de flujos de control (`guard`, `catch`, etc.). `#expect(false)` funciona pero no comunica el motivo del fallo en el log de tests.
