# myHamburgareApp — CLAUDE.md

## Project Overview

SwiftUI burger recipe app for iOS. The app displays trending burger recipes, lets users browse recipe collections, view recipe details, and includes a QR scan flow stub for future ingredient/import support.

| Component | Type | Purpose |
|-----------|------|---------|
| `myHamburgareAppApp.swift` | SwiftUI App Entry | App lifecycle, main tab navigation, environment object injection |
| `Views/` | SwiftUI Views | Home, Browse, Scan, Profile, Recipe detail interfaces |
| `ViewModels/` | Local data model + loader | Loads `Recetas.json`, provides recipe list data |
| `Assets.xcassets/` | Images + colors | App icons, burger image, themed colors |
| `Launch Screen.storyboard` | Launch UI | App launch screen |

**Frameworks:** SwiftUI, Foundation
**Project type:** iOS app using SwiftUI app lifecycle
**Swift version:** likely Swift 5+ with SwiftUI

---

## Targets

| Target | Platform | Purpose |
|--------|----------|---------|
| `myHamburgareApp` | iOS | Main app target |

---

## Architecture

### Data Flow

```
Recetas.json → RecipeViewModel → Views (HomeView, BrowseView, ProfileView, RecipeView)
```

### Entry Point

`myHamburgareAppApp.swift` creates `TabSelection` as a shared `@StateObject` and injects it into the environment. `AnimatedTabView` renders the app's tab bar and swaps the main screen content.

```swift
@StateObject private var tabSelection = TabSelection()

WindowGroup {
    AnimatedTabView()
        .environmentObject(tabSelection)
}
```

### Navigation

The app uses a custom bottom tab bar in `AnimatedTabView` with four tabs:

| Tab | View | Purpose |
|-----|------|---------|
| Home | `HomeView` | Trending and featured recipes |
| Browse | `BrowseView` | Searchable recipe grid and category tags |
| Scan | `ScanView` | QR scan onboarding stub |
| Profile | `ProfileView` | User profile, recipe library, settings tab |

---

## Core Models

### Recipe models

- `Recipe` — Codable recipe entity with name, description, category, time, calories, difficulty, steps, ingredients, and shopping list.
- `RecipeCategory` — categories: `carne`, `vegana`, `vegetariana`.
- `DifficultyLevel` — difficulty values: `fácil`, `medio`, `difícil`.
- `RecipeViewModel` — loads `Recetas.json` from bundle and publishes `recipes`.
- `RecipeCollection` / `RecipeManager` — convenience helpers for filtering and searching recipe data.

---

## Views

- `HomeView.swift`
  - Shows a horizontal trending carousel and a featured recipe list.
  - Pulls recipe data from `RecipeViewModel`.

- `BrowseView.swift`
  - Displays search input, category tags, and a responsive recipe grid.
  - Uses a two-column `LazyVGrid` for recipe cards.

- `ScanView.swift`
  - QR scan entry UI with a camera action placeholder.
  - Includes a back button to return to Home.

- `ProfileView.swift`
  - Shows a user profile header, tabbed content for "My recipes" and "Settings".
  - Displays recipe cards in a grid when "My recipes" is active.

- `RecipeView.swift`
  - Detailed recipe screen with header, ingredients checklist, instructions checklist, and review UI.

---

## Assets

- `Assets.xcassets/Hamburgere.imageset` — burger image used in lists and cards.
- `Assets.xcassets/Accento.colorset` — custom accent color.
- `Assets.xcassets/Background.colorset` — background color asset.
- `Assets.xcassets/Primary_my.colorset` / `Secondary_my.colorset` — additional app colors.

---

## Notes

- The app currently uses local JSON data and placeholder UI for search, scan, and settings actions.
- `ScanView` and `ProfileView` include navigation/button stubs for future functionality.
- `RecipeViewModel` logs loading status and handles missing JSON gracefully.
- `Recipe` model uses computed display strings for `executionTimeFormatted` and `caloriesFormatted`.

---

## File Reference Map

```
myHamburgareApp/
├── myHamburgareAppApp.swift
├── ContentView.swift
├── Launch Screen.storyboard
├── Assets.xcassets/
├── ViewModels/
│   ├── RecipeViewModel.swift
│   ├── recipe_data_model.swift
│   └── Recetas.json
└── Views/
    ├── HomeView.swift
    ├── BrowseView.swift
    ├── ScanView.swift
    ├── ProfileView.swift
    └── RecipeView.swift
```

---

## Next Steps

1. Implement recipe selection/navigation from `BrowseView` and `HomeView` into `RecipeView`.
2. Replace placeholder scan camera action in `ScanView` with real image/QR scanning functionality.
3. Add search filtering and tag-based recipe filtering in `BrowseView`.
4. Expand `ProfileView` settings content and persist user preferences.

---

## Ticket Summary

- `TICKET-001`: Connect recipe cards in `HomeView` and `BrowseView` to navigate into `RecipeView` with the selected recipe details.
- `TICKET-002`: Implement actual QR/image scanning flow in `ScanView` and parse scanned recipes into app state.
- `TICKET-003`: Add functional search and category/tag filters in `BrowseView` using `RecipeViewModel` data.
- `TICKET-004`: Expand `ProfileView` "Settings" panel and save user preferences locally.
- `TICKET-005`: Improve `Recipe` model to support real image data and dynamic detail rendering in `RecipeView`.
- `TICKET-006`: Clean up unused views/code and unify navigation structure so `NavigationView` wrappers are consistent.
