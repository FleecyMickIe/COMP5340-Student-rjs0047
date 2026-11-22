import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var auth: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var confirmation = ""
    @State private var isSigningUp = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.system(size: 52))
                            .foregroundStyle(.teal)
                        Text("Recipe Room")
                            .font(.largeTitle.bold())
                        Text("Your next meal starts here.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 16)
                }

                Section(isSigningUp ? "Create your account" : "Welcome back") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityLabel("Email")
                    SecureField("Password", text: $password)
                        .textContentType(isSigningUp ? .newPassword : .password)
                        .accessibilityLabel("Password")
                    if isSigningUp {
                        SecureField("Confirm password", text: $confirmation)
                            .textContentType(.newPassword)
                            .accessibilityLabel("Confirm password")
                    }
                }
                .disabled(auth.isBusy)

                if let message = auth.errorMessage {
                    Section {
                        Label(message, systemImage: "exclamationmark.circle")
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Button {
                        Task {
                            if isSigningUp {
                                await auth.signUp(email: email, password: password, confirmation: confirmation)
                            } else {
                                await auth.logIn(email: email, password: password)
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            if auth.isBusy { ProgressView() }
                            Text(isSigningUp ? "Create Account" : "Log In")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(auth.isBusy)

                    Button(isSigningUp ? "Already have an account? Log in" : "New here? Create an account") {
                        isSigningUp.toggle()
                        password = ""
                        confirmation = ""
                        auth.errorMessage = nil
                    }
                    .disabled(auth.isBusy)
                }
            }
            .navigationTitle(isSigningUp ? "Sign Up" : "Log In")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
