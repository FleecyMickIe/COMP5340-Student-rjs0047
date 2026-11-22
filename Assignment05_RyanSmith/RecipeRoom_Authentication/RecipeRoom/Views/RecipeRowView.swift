import SwiftUI

struct RecipeRowView: View {
    let recipe: RecipeModel

    var body: some View {
        HStack(spacing: 16) {
            RecipeImageView(imageURL: recipe.imageURL)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.displayName)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(recipe.category ?? "Uncategorized")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let cuisine = recipe.cuisine, !cuisine.isEmpty {
                    Text(cuisine)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 6)
    }
}
