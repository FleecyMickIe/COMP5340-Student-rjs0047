import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipesViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Finding something delicious…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let message = viewModel.errorMessage {
                    ContentUnavailableView {
                        Label("Unable to Load Recipes", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text(message)
                    } actions: {
                        Button("Try Again") {
                            Task { await viewModel.loadRecipes() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if viewModel.recipes.isEmpty {
                    ContentUnavailableView {
                        Label("No Recipes Found", systemImage: "fork.knife")
                    } description: {
                        Text("There are no recipes to display right now.")
                    } actions: {
                        Button("Reload Recipes") {
                            Task { await viewModel.loadRecipes() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        Section {
                            Label("EAT EAT EAT.", systemImage: "fork.knife.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 6)
                        }
                        Section("Explore Recipes") {
                            ForEach(viewModel.recipes) { recipe in
                                NavigationLink {
                                    RecipeDetailView(recipe: recipe)
                                } label: {
                                    RecipeRowView(recipe: recipe)
                                }
                            }
                        }
                        Section {
                            Text("Recipes and photos provided by TheMealDB.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable {
                        await viewModel.loadRecipes()
                    }
                }
            }
            .navigationTitle("Recipe Room")
            .task { await viewModel.loadRecipes() }
        }
        .tint(.teal)
    }
}

#Preview {
    RecipeListView()
}
