// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AuthenticationServices
import Combine
import SwiftUI

struct LoginView: View {
    // MARK: Internal

    @EnvironmentObject var authManager: AuthManager

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
        .animation(.default, value: self.credentials.isEmailValid())
        .animation(.default, value: self.credentials.isPasswordValid(self.credentials.password))
        .sheet(isPresented: self.$showSheet) { ForgotPasswordView() }
        .alert("An error occurred", isPresented: self.$showErrorAlert) {
            // nothing to show
        } message: {
            Text(self.authManager.errorMessage)
        }
        .onReceive(self.authManager.$showErrorAlert) { newValue in
            self.showErrorAlert = newValue
        }
        .alert("Réinitialiser le mot de passe", isPresented: self.$authManager.showNotificationAlert) {
            // nothing to show
        } message: {
            Text(self.authManager.notificationMessage)
        }
    }

    // MARK: Private

    @State private var credentials = CredentialsViewModel.shared
    @State private var showSheet: Bool = false
    @State private var showErrorAlert = false

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("email", text: self.$credentials.mail)
                .textFieldStyle(.roundedBorder)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .onReceive(Just(self.credentials.mail)) { newValue in
                    self.credentials.mail = newValue.trimmingCharacters(in: .whitespaces)
                }
            if !self.credentials.mail.isEmpty,
               !self.credentials.isEmailValid()
            {
                Text(self.credentials.invalidEmailAddressText)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 10) {
            SecureField("password", text: self.$credentials.password)
                .textFieldStyle(.roundedBorder)
                .textContentType(.password)
                .onReceive(Just(self.credentials.password)) { newValue in
                    self.credentials.password = newValue.trimmingCharacters(in: .whitespaces)
                }
            if !self.credentials.password.isEmpty,
               !self.credentials.isPasswordValid(self.credentials.password)
            {
                Text(self.credentials.invalidPasswordText)
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
                self.authManager.signIn(
                    email: self.credentials.mail,
                    password: self.credentials.password
                )
            },
            label: {
                Text("Log In")
                    .frame(maxWidth: .infinity)
            }
        )
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .disabled(!self.credentials.logInIsComplete)
        .animation(.default, value: self.credentials.logInIsComplete)
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
