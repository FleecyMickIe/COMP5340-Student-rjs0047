# Recipe Room

A small SwiftUI educational app for Assignment 4. It requests recipes from
TheMealDB, decodes JSON into Swift models, displays a recipe list, and opens a
detail screen containing cooking instructions. This first version focuses on
photos, category, cuisine, and instructions; it does not display an ingredient list.

## Open and run

1. Unzip this folder on your Mac.
2. Open `RecipeRoom.xcodeproj` in Xcode 16 or newer.
3. Select the RecipeRoom scheme and an iPhone simulator running iOS 17 or newer.
4. Press Command-R. An internet connection is required to load recipes and photos.
5. For a physical iPhone, choose your own development team under Signing & Capabilities.

This is a separate app. Do not add its @main App file to your National Parks app.
The project uses Xcode's synchronized folders: its Swift files appear automatically
under the RecipeRoom folder in Xcode. No private API key or account is required.

## Learn the files in this order

1. **Models/RecipeModel.swift** describes a recipe and the response envelope.
   `Decodable` converts JSON to these structures; `CodingKeys` maps JSON names to
   readable Swift names. `Identifiable` uses the API's stable recipe ID.
2. **Services/RecipeService.swift** performs the network request with URLSession,
   checks the HTTP status, and decodes the response with JSONDecoder.
3. **ViewModels/RecipesViewModel.swift** owns recipes, loading state, and an error
   message. `@Published` tells the interface when values change. `@MainActor`
   keeps UI state updates on the main actor.
4. **Views/RecipeListView.swift** owns the view model with `@StateObject`, starts
   loading with `.task`, and chooses loading, error, empty, or list content.
5. **Views/RecipeRowView.swift** is the reusable name/photo/category/cuisine row.
6. **Views/RecipeImageView.swift** loads remote images and shows placeholders.
7. **Views/RecipeDetailView.swift** displays the selected recipe's instructions.
8. **RecipeRoomApp.swift** is the app entry point.

The detail screen receives the selected decoded recipe, so it does not need a
second API request. System text and background colors support light and dark mode.

## API

Educational endpoint: https://www.themealdb.com/api/json/v1/1/search.php?s=
Documentation: https://www.themealdb.com/api.php
The `1` in the URL is the public educational test key. A blank search returns a
selection of recipes rather than the entire database. Follow the provider's
current terms before publishing to an app store. Recipes and photos belong to
their respective providers; the interface includes TheMealDB attribution.

## Assignment 4 mapping

| Requirement | Implementation |
| --- | --- |
| Network API request | RecipeService uses URLSession |
| JSON models | RecipeResponse and RecipeModel conform to Decodable |
| Scrollable results | List, ForEach, RecipeRowView |
| Detail navigation | NavigationLink opens RecipeDetailView |
| Additional detail | Cooking instructions |
| Loading | ProgressView |
| Errors | Message and Try Again button |
| Empty results | No Recipes Found message and Reload button |
| Missing fields/images | Optional text fields and image placeholders |
| Organization | Models, Services, ViewModels, Views |
| Consistent design | Teal accent, rounded photos, system text/background colors |

## Checks to perform in Xcode before submission

- Launch with an internet connection: recipes and photos should load.
- Open several recipes, read instructions, and navigate back.
- Pull down the recipe list to refresh.
- Disable the Mac's network connection (a simulator uses the Mac's network), then
  launch the app to check the error screen. Restore connectivity and tap Try Again.
- Check light mode, dark mode, a smaller iPhone, and larger accessibility text.
- For the empty state, temporarily replace `return result.meals ?? []` with
  `return []` in RecipeService. Run the app, then restore the original line.
- To check missing data, temporarily use `null` for optional fields in a local
  decoding fixture; the production app always uses the network request.

## Validation status

The live API returned HTTP 200 and 25 recipes during preparation. The JSON field
names and project structure were checked. Xcode and an Apple SDK were not available
in the preparation environment, so an iOS build and simulator verification remain
required on your Mac. No App Store icon has been provided; the app uses a system
symbol for its in-app visual branding.
