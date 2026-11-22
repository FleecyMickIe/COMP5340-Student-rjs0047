import SwiftUI


struct RecipeImageView: View {
    let imageURL: String?

    var body: some View {
        AsyncImage(url: imageURL.flatMap { URL(string: $0) }) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.teal.opacity(0.12)
                    if phase.error != nil || imageURL == nil || imageURL == "" {
                        Image(systemName: "fork.knife")
                            .font(.title2)
                            .foregroundStyle(.teal)
                            .accessibilityLabel("Recipe photo unavailable")
                    } else {
                        ProgressView()
                    }
                }
            }
        }
    }
}
