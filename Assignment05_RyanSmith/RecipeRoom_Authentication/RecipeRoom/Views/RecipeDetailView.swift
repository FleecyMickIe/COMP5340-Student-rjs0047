import SwiftUI

struct RecipeDetailView: View {
    let recipe: RecipeModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
               
                Color.clear
                    .frame(height: 240)
                    .overlay {
                        RecipeImageView(imageURL: recipe.imageURL)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .accessibilityLabel("Photo of \(recipe.displayName)")

                Text(recipe.displayName)
                    .font(.largeTitle)
                    .bold()

                VStack(alignment: .leading, spacing: 12) {
                    Label(recipe.category ?? "Uncategorized", systemImage: "fork.knife")
                    Label(recipe.cuisine ?? "Cuisine not listed", systemImage: "globe")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Cooking Instructions")
                        .font(.title2)
                        .bold()
                    Text(recipe.displayInstructions)
                        .lineSpacing(6)
                        .textSelection(.enabled)
                }

                Text("Recipe provided by TheMealDB")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
