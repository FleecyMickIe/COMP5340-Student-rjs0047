import SwiftUI
import FirebaseCore

@main
struct RecipeRoomApp: App {
    private let firebaseConfigured: Bool

    init() {
        // Configure Firebase before RootView creates the authentication model.
        if Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist") != nil {
            FirebaseApp.configure()
            firebaseConfigured = true
        } else {
            firebaseConfigured = false
        }
    }

    var body: some Scene {
        WindowGroup {
            if firebaseConfigured {
                RootView()
            } else {
                ContentUnavailableView(
                    "Firebase Setup Needed",
                    systemImage: "gearshape",
                    description: Text("Add your Recipe Room GoogleService-Info.plist to the app target, then rebuild. See SETUP_GUIDE.md.")
                )
            }
        }
    }
}
