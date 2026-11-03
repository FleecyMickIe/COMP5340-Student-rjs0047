//
// Favorites_CompletedApp.swift : Favorites_Completed
//
// Copyright © 2025 Auburn University.
// All Rights Reserved.

//rjs0047

import SwiftUI

@main
struct FavoritesApp: App {
    
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesViewModel)
        }
    }
}
