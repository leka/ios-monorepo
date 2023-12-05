// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AuthenticationServices
import SwiftUI

struct LoginView: View {
    // MARK: Internal

    @EnvironmentObject var authManager: AuthManager
    @State private var credentials = CompanyCredentialsViewModel()
    @State private var showSheet: Bool = false
    @State private var showErrorAlert = false

    var body: some View {
        VStack(spacing: 10) {
            self.emailField
            self.passwordField
            self.loginButton
            self.forgotLink
        }
        .textInputAutocapitalization(.never)
        .frame(maxWidth: 400)
        .padding()
        .navigationTitle("Login View")
        .navigationBarTitleDisplayMode(.large)
        .animation(.default, value: credentials.isEmailValid())
        .animation(.default, value: credentials.isPasswordValid(credentials.password))
        .sheet(isPresented: $showSheet) { ForgotPasswordView() }
        .alert("An error occurred", isPresented: $showErrorAlert) {
            // nothing to show
        } message: {
            Text(authManager.errorMessage)
        }
        .onReceive(authManager.$showErrorAlert) { newValue in
            showErrorAlert = newValue
        }
        .alert("Réinitialiser le mot de passe", isPresented: $authManager.showNotificationAlert) {
            // nothing to show
        } message: {
            Text(authManager.notificationMessage)
        }
    }

    // MARK: Private

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("email", text: $credentials.mail)
                .textFieldStyle(.roundedBorder)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
            if !credentials.mail.isEmpty
                && !credentials.isEmailValid()
            {
                Text(credentials.invalidEmailAddressText)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 10) {
            SecureField("password", text: $credentials.password)
                .textFieldStyle(.roundedBorder)
                .textContentType(.password)
            if !credentials.password.isEmpty
                && !credentials.isPasswordValid(credentials.password)
            {
                Text(credentials.invalidPasswordText)
                    .font(.footnote)
                    .lineLimit(2)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
        .padding(.bottom, 10)
    }

    private var loginButton: some View {
        Button(
            action: {
                authManager.signIn(
                    email: credentials.mail,
                    password: credentials.password
                )
            },
            label: {
                Text("Log In")
                    .frame(maxWidth: .infinity)
            }
        )
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .disabled(!credentials.logInIsComplete)
        .animation(.default, value: credentials.logInIsComplete)
    }

    private var forgotLink: some View {
        HStack {
            Spacer()
            Button(
                action: {
                    self.showSheet = true
                },
                label: {
                    Text("Forgot Password")
                        .font(.footnote)
                        .underline()
                        .padding(.trailing, 10)
                }
            )
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
