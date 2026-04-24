# TODO

## High Priority

- [x] TICKET-001: Connect recipe cards in `HomeView` and `BrowseView` to navigate into `RecipeView` with the selected recipe details.
- [x] TICKET-002: Implement actual QR/image scanning flow in `ScanView` and parse scanned recipes into app state.
- [x] TICKET-003: Add functional search and category/tag filters in `BrowseView` using `RecipeViewModel` data.
- [x] TICKET-004: Expand `ProfileView` "Settings" panel and save user preferences locally.

## Medium Priority

- [x] TICKET-005: Improve `Recipe` model to support real image data and dynamic detail rendering in `RecipeView`.
- [x] TICKET-006: Clean up unused views/code and unify navigation structure so `NavigationView` wrappers are consistent.

## Notes

- The project currently uses a local JSON dataset in `ViewModels/Recetas.json`.
- `ScanView` and `ProfileView` currently contain placeholder actions.
- `myHamburgareAppApp.swift` uses a custom `AnimatedTabView` with `TabSelection` injected as an `EnvironmentObject`.

## Suggested follow-up tasks

1. Add `Recipe` selection state and pass selected recipe data to `RecipeView`.
2. Replace sketch placeholder UI in `RecipeView` with dynamic recipe content and real images.
3. Review all `NavigationView` instances and consolidate nested navigation to avoid unexpected behavior.
4. Create unit tests for `RecipeViewModel` JSON loading and search/filter behavior.