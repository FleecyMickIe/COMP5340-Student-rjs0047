import Foundation


struct RecipeResponse: Decodable {
    let meals: [RecipeModel]?
}

struct RecipeModel: Decodable, Identifiable {
    let id: String
    let name: String?
    let category: String?
    let cuisine: String?
    let instructions: String?
    let imageURL: String?

   
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case cuisine = "strArea"
        case instructions = "strInstructions"
        case imageURL = "strMealThumb"
    }

    var displayName: String {
        guard let name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Untitled recipe"
        }
        return name
    }

    
    var displayInstructions: String {
        guard let instructions,
              !instructions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Cooking instructions are not available for this recipe."
        }
        return instructions
    }
}
