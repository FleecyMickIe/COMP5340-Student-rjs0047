import Foundation
import Combine


@MainActor
final class RecipesViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = RecipeService()

    func loadRecipes() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

    
        defer { isLoading = false }

        do {
            let loadedRecipes = try await service.fetchRecipes()
            try Task.checkCancellation()
            recipes = loadedRecipes
        } catch is CancellationError {
   
        } catch let error as URLError where error.code == .cancelled {
        } catch {
            errorMessage = "We couldn't load recipes. Check your connection and try again."
        }
    }
}
