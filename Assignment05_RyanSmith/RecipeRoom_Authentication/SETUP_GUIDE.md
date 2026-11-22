# Recipe Room — Firebase Authentication Setup

This is a separate copy of Assignment 4, extended for the authentication assignment.
The display name remains Recipe Room. Its new bundle identifier is:

`edu.auburn.rjs0047.RecipeRoomAuth`

The separate identifier lets you keep your original Recipe Room simulator app installed.
You may change the identifier, but it must match the iOS app registration in Firebase.

## 1. Open the supplied project

Unzip RecipeRoom_Authentication.zip. Open RecipeRoom.xcodeproj inside the extracted
RecipeRoom_Authentication folder. Use your current Xcode (26.2 or newer for the
current Firebase SDK). The app targets iOS 17 or newer.

Wait while Xcode resolves Firebase packages. FirebaseAuth and FirebaseCore are already
linked in this project, using the Firebase 13.x release line, starting at 13.2.0.
Do not add FirebaseFirestore; this assignment uses Authentication, not a database.
If package resolution fails, record Xcode's actual error before changing versions.

## 2. Create or select a Firebase project

Open https://console.firebase.google.com/ and sign in with your own account.
Create a project named Recipe Room (or select a Firebase project you own).
Google Analytics is optional and is not needed here.

If you reuse your Notes Firebase project, register Recipe Room as another iOS app
inside it. Do not reuse the Notes app's configuration file: the bundle IDs differ.
Accounts are shared by apps registered within one Firebase project. A separate
Firebase project keeps the classroom apps' account lists independent.

## 3. Register Recipe Room as an Apple app

From your Firebase project's overview, add an iOS/Apple app. You can also find
Add app under Project settings > General > Your apps.

- Apple bundle ID: `edu.auburn.rjs0047.RecipeRoomAuth`
- App nickname: Recipe Room Auth (optional)
- App Store ID: leave blank

In Xcode you can confirm the identifier under project > RecipeRoom target >
Signing & Capabilities. Register the exact identifier shown there.

Download GoogleService-Info.plist. Keep that exact filename (no spaces, suffixes,
or '(1)'). Place the file physically inside the inner RecipeRoom source folder,
beside RecipeRoomApp.swift. The outer folder contains the .xcodeproj; the inner
RecipeRoom folder contains Swift files.

This project uses Xcode synchronized folders, so files in the inner source folder
are picked up automatically. If you use Xcode's Add Files dialog instead, choose
Copy items if needed and the RecipeRoom target when those options appear.
Confirm GoogleService-Info.plist is included in the target's resources. Add only
one copy; duplicate copies can cause a Multiple commands produce build error.

If you run without this file, the app displays Firebase Setup Needed. That is a
setup reminder, not a working authentication screen. Rebuild after adding it.
A malformed file or configuration for a different bundle ID still needs correction.

## 4. Enable email/password authentication

In Firebase Console, open Authentication (under Build or Security depending on the
console layout). Click Get started if shown. Open Sign-in method, select
Email/Password, enable the Email/Password option, and save. Email-link/passwordless
sign-in is not required.

Firebase validates password requirements. With the default policy the minimum is
six characters; choose a stronger test password and follow any policy you configured.
You do not need to manually add users: the app's Create Account button creates them.

## 5. Run in the simulator

Select the RecipeRoom scheme and an iPhone simulator. Press Command-R.
You should see the Recipe Room login form. Tap New here? Create an account.
Enter an email, a test password, and the same password in Confirm password.
Tap Create Account. Firebase creates the account and signs it in; the recipe list
then appears. In Firebase Console > Authentication > Users, confirm the account exists.

Do not put test passwords into source files, screenshots, README files, or GitHub.
No administrator credentials or service-account file belong in this app.

## 6. Understand the code in this order

### RecipeRoomApp.swift — initialize Firebase

The app checks for its configuration file and calls FirebaseApp.configure() before
creating the authentication model. It opens RootView rather than the recipe list.

### AuthViewModel.swift — own the shared session

@Published user tells the interface which account is signed in. @MainActor keeps
UI state changes on the main actor. addStateDidChangeListener reports the initial
session and changes after signup, login, or logout. isCheckingSession prevents
showing the login form while the initial session is being resolved.

logIn calls Firebase signIn. signUp calls createUser. logOut calls signOut.
Firebase manages session credentials; the app never saves a password in UserDefaults.
The model translates common Firebase errors into readable messages. It disables
repeat submissions while a request is in progress and removes its listener when freed.

### RootView.swift — decide which screen is visible

@StateObject creates one authentication model. The root shows a progress indicator,
a login form, or RecipeListView. environmentObject shares the same model with child
views. Login is not pushed onto the recipe navigation stack, so Back cannot reveal
recipes after logout. The selected recipe screen disappears with its signed-in branch.

### LoginView.swift — collect email and password

TextField collects email. SecureField hides passwords. @State stores the form's
current input. A button switches between login and account creation. Signup adds
a confirmation field. Errors are displayed inline; Task runs the async Firebase call.

### RecipeListView.swift — existing recipes plus logout

The original recipe list, retry controls, refresh, and detail navigation remain.
A toolbar button calls auth.logOut(). A logout failure shows an alert. Successful
logout is reflected by the root's authentication listener.

## 7. Run the acceptance checks

Do not call the project complete until these pass on your Mac:

| Check | Expected result |
| --- | --- |
| Create a new account | Recipe list appears; user is listed in Firebase |
| Open a recipe | Existing detail screen and instructions work |
| Tap Log Out | Login form appears; recipe screen is gone |
| Log in with valid credentials | Recipe list appears |
| Log in with a wrong password | Error message; stays on login form |
| Submit blank fields | Message asks for email/password |
| Signup passwords do not match | Message; account is not created |
| Invalid email or rejected weak password | Readable Firebase error message |
| Sign in, stop app, launch again | Existing session opens recipe list |
| Log out, stop app, launch again | Login form remains |
| Attempt login without internet | Error; button becomes available to retry |
| Light/dark mode and large text | Form remains readable and scrollable |

Use stopping and relaunching for the session test, not deleting and reinstalling
the app. iOS Keychain behavior can preserve credentials across reinstalls.
If Firebase works but the recipe API is unavailable, you may see the recipe error
screen after login. That is a separate network request; Log Out is still available.

## 8. Submit to GitHub

Keep Assignment 4 intact. Add this folder under a new assignment folder in your
class repository, or publish a separate repository if the instructor requires one.
Upload/commit the extracted project files, not only a ZIP.

Include the .xcodeproj/project.pbxproj, source files, resources, README.md, and this
guide. The .gitignore excludes build output, macOS files, and Xcode user settings.
Commit Package.resolved once Xcode generates it so the resolved SDK versions are recorded.

The Firebase client GoogleService-Info.plist identifies the Firebase project; it is
not an administrator/service-account credential. This delivered archive intentionally
has no configuration for your account. Before submitting, include the correct client
configuration if your instructor needs the cloned app to run, or agree on another
way to provide it and document setup. Never include Firebase service-account JSON.

From the local class repository root, after putting the project under your chosen
new assignment folder, stage that specific folder, review git diff --cached --stat,
then commit and push. Use your actual folder name rather than assuming an assignment
number. Submit the GitHub link to the new assignment's folder or repository.

## Scope

This is a classroom authentication flow around a public recipe browser. Login gates
the app's interface; it does not make TheMealDB's public endpoint private. The
assignment does not require private recipe storage, Firestore, account deletion,
password reset, email verification, or another authentication provider.

## References

- https://firebase.google.com/docs/ios/setup
- https://firebase.google.com/docs/auth/ios/password-auth
- https://firebase.google.com/docs/auth/ios/start
- https://firebase.google.com/docs/auth/ios/manage-users

## Validation status

The source changes, package references, file paths, and ZIP structure were checked.
Xcode and Apple SDKs are unavailable in the preparation environment. Compilation,
live Firebase signup/login/logout, and simulator session tests have not been run.
Your Firebase Console setup and the acceptance checks above are still required.
