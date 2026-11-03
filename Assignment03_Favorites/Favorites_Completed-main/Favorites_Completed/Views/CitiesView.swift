//
// CitiesView.swift : Favorites
//
// Copyright © 2025 Auburn University.
// All Rights Reserved.

//rjs0047


import SwiftUI

struct CitiesView: View {
    
    @EnvironmentObject var favorites: FavoritesViewModel
    @Binding var searchText: String
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(favorites.filteredCities(searchText: searchText)) { city in
                    CityCardView(city: city)
                }
            }
            .padding()
        }
    }
}

#Preview {
    CitiesView(searchText: .constant(""))
        .environmentObject(FavoritesViewModel())
}
