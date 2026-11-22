import Foundation
import Combine
import FirebaseAuth

// One shared model manages the session for the whole app.
@MainActor
final class AuthViewModel: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var isCheckingSession = true
    @Published private(set) var isBusy = false
    @Published var errorMessage: String?

    private var listener: AuthStateDidChangeListenerHandle?

    init() {
        // Firebase restores its saved session and reports login/logout changes here.
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor [weak self] in
                self?.user = user
                self?.isCheckingSession = false
            }
        }
    }

    deinit {
        if let listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }

    func logIn(email: String, password: String) async {
        guard !isBusy else { return }
        errorMessage = nil
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Enter your email and password."
            return
        }
        isBusy = true
        defer { isBusy = false }
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            errorMessage = message(for: error)
        }
    }

    func signUp(email: String, password: String, confirmation: String) async {
        guard !isBusy else { return }
        errorMessage = nil
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Enter your email and password."
            return
        }
        guard password == confirmation else {
            errorMessage = "Your passwords do not match."
            return
        }
        isBusy = true
        defer { isBusy = false }
        do {
            // Firebase also signs in the newly created account.
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            errorMessage = message(for: error)
        }
    }

    func logOut() {
        guard !isBusy else { return }
        errorMessage = nil
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = "We couldn't log you out. Please try again."
        }
    }

    private func message(for error: Error) -> String {
        let code = (error as NSError).code
        switch code {
        case AuthErrorCode.invalidEmail.rawValue:
            return "Enter a valid email address."
        case AuthErrorCode.wrongPassword.rawValue,
             AuthErrorCode.userNotFound.rawValue,
             AuthErrorCode.invalidCredential.rawValue:
            return "Unable to log in. Check your email and password."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Unable to create this account. Try logging in instead."
        case AuthErrorCode.weakPassword.rawValue:
            return "Choose a stronger password that meets this project's password requirements."
        case AuthErrorCode.networkError.rawValue:
            return "Check your internet connection and try again."
        case AuthErrorCode.tooManyRequests.rawValue:
            return "Too many attempts. Please wait and try again."
        case AuthErrorCode.userDisabled.rawValue:
            return "This account is disabled."
        case AuthErrorCode.operationNotAllowed.rawValue:
            return "Email/password authentication is not enabled for this Firebase project."
        default:
            return "Authentication failed. Please try again."
        }
    }
}
