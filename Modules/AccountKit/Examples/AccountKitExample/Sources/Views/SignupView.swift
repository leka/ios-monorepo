// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AuthenticationServices
import SwiftUI

struct SignupView: View {
    // MARK: Internal

    @EnvironmentObject var authManager: AuthManager
    @State private var credentials = CompanyCredentialsViewModel()
    @State private var showErrorAlert = false

    var body: some View {
        VStack(spacing: 10) {
            self.emailField
            self.passwordField
            self.confirmPasswordField
            self.signupButton
        }
        .textInputAutocapitalization(.never)
        .frame(maxWidth: 400)
        .padding()
        .navigationTitle("Sign-Up View")
        .navigationBarTitleDisplayMode(.large)
        .animation(.default, value: credentials.isEmailValid())
        .animation(.default, value: credentials.isPasswordValid(credentials.password))
        .animation(.default, value: credentials.passwordsMatch())
        .alert("An error occurred", isPresented: $showErrorAlert) {
            // nothing to show
        } message: {
            Text(authManager.errorMessage)
        }
        .onReceive(authManager.$showErrorAlert) { newValue in
            showErrorAlert = newValue
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
                .textContentType(.newPassword)
            if !credentials.password.isEmpty
                && !credentials.isPasswordValid(credentials.password)
            {
                Text(credentials.invalidPasswordText)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var confirmPasswordField: some View {
        VStack(alignment: .leading, spacing: 10) {
            SecureField("confirm password", text: $credentials.confirmPassword)
                .textFieldStyle(.roundedBorder)
                .textContentType(.password)
            if !credentials.password.isEmpty
                && (!credentials.confirmPassword.isEmpty
                    && !credentials.passwordsMatch())
            {
                Text(credentials.invalidConfirmPasswordText)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
        .padding(.bottom, 10)
    }

    private var signupButton: some View {
        Button(
            action: {
                authManager.signUp(
                    email: credentials.mail,
                    password: credentials.password
                )
            },
            label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
            }
        )
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .disabled(!credentials.signUpIsComplete)
        .animation(.default, value: credentials.signUpIsComplete)
    }
}

#Preview {
    SignupView()
        .environmentObject(AuthManager())
}
