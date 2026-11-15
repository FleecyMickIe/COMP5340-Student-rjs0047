import Foundation

struct RecipeService {
    func fetchRecipes() async throws -> [RecipeModel] {
        // "1" is TheMealDB's public educational test key, not a private credential.
        // A blank search returns a selection of recipes, not the entire database.
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return result.meals ?? []
    }
}
