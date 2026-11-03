//
//  BookRowView.swift
//  Favorites_Completed
//
//  Created by Ryan Smith on 11/3/26.
//

import SwiftUI

struct BookRowView: View {
    let book: BookModel

    @EnvironmentObject private var favorites: FavoritesViewModel

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "book.closed.fill")
                .font(.title2)
                .foregroundStyle(.blue)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(book.bookTitle)
                    .font(.headline)

                Text(book.bookAuthor)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                favorites.toggleFavoriteBook(book: book)
            } label: {
                Image(
                    systemName: book.isFavorite ? "heart.fill" : "heart"
                )
                .foregroundStyle(book.isFavorite ? .red : .gray)
                .padding(8)
            }
            .accessibilityLabel(
                book.isFavorite
                    ? "Remove \(book.bookTitle) from favorites"
                    : "Add \(book.bookTitle) to favorites"
            )
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    BookRowView(
        book: BookModel(
            id: 1,
            bookTitle: "The Hobbit",
            bookAuthor: "J.R.R. Tolkien"
        )
    )
    .environmentObject(FavoritesViewModel())
}
