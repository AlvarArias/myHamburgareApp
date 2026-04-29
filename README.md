# myHamburgareApp

![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=flat&logo=swift)
![SwiftUI](https://img.shields.io/badge/SwiftUI-blue?style=flat&logo=apple)
![iOS](https://img.shields.io/badge/iOS-16+-blue?style=flat&logo=apple)
![CI](https://github.com/AlvarArias/myHamburgareApp/actions/workflows/ci.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey?style=flat)

A SwiftUI burger recipe app built with a clean MVVM architecture, Swift Testing unit tests, and a GitHub Actions CI pipeline. Browse trending recipes, explore by category, view step-by-step instructions, and check off ingredients as you cook.

---

## Features

- Trending recipe carousel on the Home screen
- Searchable recipe grid with category filters (meat, vegan, vegetarian)
- Recipe detail view with ingredients checklist and step-by-step instructions
- Difficulty and cooking time displayed per recipe
- Custom animated bottom tab bar
- QR scan screen (stub — ready for ingredient import)
- Profile screen with personal recipe library
- Local JSON-driven data — no backend required

---

## App screenshots 

<table>
  <tr>
    <td><img src="docs/Hamburgare 1.png" height="400"></td>
    <td width="20"></td>   
    <td><img src="docs/Hamburgare 2.png" height="400"></td>
  </tr>
</table>


---

## Tech Stack

| Layer | Technologies |
|-------|-------------|
| UI | SwiftUI, custom `AnimatedTabView` |
| Architecture | MVVM, `ObservableObject`, `@EnvironmentObject` |
| Data | Local JSON (`Recetas.json`), `Codable` models |
| Testing | Swift Testing (`@Test` macro), XCTest |
| CI/CD | GitHub Actions (macos-15, Xcode 16) |

---

## Project Structure

```
myHamburgareApp/
├── myHamburgareAppApp.swift     ← App entry, TabSelection environment injection
├── ViewModels/
│   ├── RecipeViewModel.swift    ← Loads Recetas.json, publishes recipe list
│   ├── recipe_data_model.swift  ← Recipe, RecipeCategory, DifficultyLevel models
│   └── Recetas.json             ← Local recipe data
└── Views/
    ├── HomeView.swift           ← Trending carousel + featured recipe list
    ├── BrowseView.swift         ← Search bar, category tags, LazyVGrid
    ├── ScanView.swift           ← QR scan entry point (stub)
    ├── ProfileView.swift        ← User profile + recipe library grid
    └── RecipeView.swift         ← Full recipe detail with checklist UI

myHamburgareAppTests/
├── RecipeTests.swift            ← Swift Testing unit tests for models and ViewModel
└── Recetas.json                 ← Test fixture data
```

---

## Architecture

Data flows in one direction through the MVVM layers:

```
Recetas.json
     ↓
RecipeViewModel (ObservableObject)
     ↓
SwiftUI Views — read-only, no business logic
```

`TabSelection` is injected as an `@EnvironmentObject` at the app root and drives tab switching across the custom animated tab bar.

### Recipe model

```swift
struct Recipe: Codable, Identifiable {
    var name: String
    var description: String
    var category: RecipeCategory       // .carne | .vegana | .vegetariana
    var difficulty: DifficultyLevel    // .facil | .medio | .dificil
    var executionTime: Int             // minutes
    var calories: Int
    var ingredients: [String]
    var steps: [String]
}
```

---

## CI/CD

Every push and pull request to `main` triggers the GitHub Actions pipeline:

- Runs on `macos-15` with Xcode 16
- Resolves Swift Package dependencies
- Builds the scheme without code signing (`CODE_SIGNING_ALLOWED=NO`)
- Executes the Swift Testing suite on the iPhone 16 simulator
- Uploads `TestResults.xcresult` as an artifact on failure

---

## Getting Started

```bash
git clone https://github.com/AlvarArias/myHamburgareApp.git
cd myHamburgareApp
open myHamburgareApp.xcodeproj
```

> Requires Xcode 16+ and an iOS 16 simulator or physical device.  
> No external dependencies or API keys needed — the app runs entirely on local data.

---

## License

Available under the [MIT](LICENSE) license.

---

Developed by [Alvar Arias](https://github.com/AlvarArias) · [LinkedIn](https://www.linkedin.com/in/alvararias/) · [Portfolio](https://alvararias.github.io/)
