# Recipe Room — Firebase Authentication

An extension of Recipe Room for the Firebase Authentication assignment.

- Email/password signup and login
- Session-driven navigation to the existing recipe list and details
- Authentication error messages and progress indication
- Logout button and session restoration through Firebase
- Original remote recipes and images from TheMealDB

**Start with [SETUP_GUIDE.md](SETUP_GUIDE.md).** The Firebase SDK is linked, but you
must register the app, add its GoogleService-Info.plist, and enable Email/Password
in Firebase Console. No Firebase account configuration is included in this archive.

Bundle ID: `edu.auburn.rjs0047.RecipeRoomAuth`
Requires iOS 17+ and Xcode compatible with Firebase 13.x (current setup docs specify
Xcode 26.2+). Open RecipeRoom.xcodeproj and run the RecipeRoom scheme.

| Assignment requirement | Implementation |
| --- | --- |
| Email/password signup | LoginView and AuthViewModel.signUp |
| Email/password login | LoginView and AuthViewModel.logIn |
| Home after authentication | RootView displays RecipeListView |
| Session management | Firebase authentication-state listener |
| Error states | Inline form errors and logout error alert |
| Logout | Recipe list toolbar, AuthViewModel.logOut |

New files: AuthViewModel.swift, RootView.swift, LoginView.swift.
Updated: RecipeRoomApp.swift, RecipeListView.swift, project.pbxproj.
Existing recipe models, service, view model, images, rows, and detail view are reused.

The code has not been compiled or tested in an iOS simulator here. Perform the
acceptance checks in the setup guide before submission. Do not commit passwords
or administrator credentials. Recipe content and photos are provided by TheMealDB.
