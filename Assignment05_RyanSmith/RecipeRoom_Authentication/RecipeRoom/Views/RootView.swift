import SwiftUI

struct RootView: View {
    @StateObject private var auth = AuthViewModel()

    var body: some View {
        Group {
            if auth.isCheckingSession {
                ProgressView("Opening Recipe Room…")
            } else if let user = auth.user {
                RecipeListView()
                    .id(user.uid)
            } else {
                LoginView()
            }
        }
        .environmentObject(auth)
        .tint(.teal)
    }
}
