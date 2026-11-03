//
// FavoritesView.swift : Favorites
//
// Copyright © 2025 Auburn University.
// All Rights Reserved.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favorites: FavoritesViewModel

    var favoriteCities: [CityModel] {
        favorites.cities.filter { $0.isFavorite }
    }

    var favoriteHobbies: [HobbyModel] {
        favorites.hobbies.filter { $0.isFavorite }
    }

    var favoriteBooks: [BookModel] {
        favorites.books.filter { $0.isFavorite }
    }

    var hasFavorites: Bool {
        !favoriteCities.isEmpty
            || !favoriteHobbies.isEmpty
            || !favoriteBooks.isEmpty
    }

    var body: some View {
        NavigationStack {
            Group {
                if hasFavorites {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            if !favoriteCities.isEmpty {
                                Text("Cities")
                                    .font(.title2)
                                    .bold()

                                ForEach(favoriteCities) { city in
                                    CityCardView(city: city)
                                }
                            }

                            if !favoriteHobbies.isEmpty {
                                Text("Hobbies")
                                    .font(.title2)
                                    .bold()

                                ForEach(favoriteHobbies, id: \.hobbyName) { hobby in
                                    HobbyRowView(hobby: hobby)
                                }
                            }

                            if !favoriteBooks.isEmpty {
                                Text("Books")
                                    .font(.title2)
                                    .bold()

                                ForEach(favoriteBooks, id: \.bookTitle) { book in
                                    BookRowView(book: book)
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "heart")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)

                        Text("No Favorites Yet")
                            .font(.title2)
                            .bold()

                        Text("Tap a heart while browsing to save an item here.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesViewModel())
}
