//
// HobbiesView.swift : Favorites
//
// Copyright © 2025 Auburn University.
// All Rights Reserved.

//rjs0047


import SwiftUI

struct HobbiesView: View {
    
    @EnvironmentObject var favorites: FavoritesViewModel
    @Binding var searchText: String
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(favorites.filteredHobbies(searchText: searchText)) { hobby in
                    HobbyRowView(hobby: hobby)
                }
            }
            .padding()
        }
    }
}
