// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AuthenticationServices
import SwiftUI

struct SignupView: View {
    // MARK: Internal

    @EnvironmentObject var authManager: AuthManager

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
        .animation(.default, value: self.credentials.isEmailValid())
        .animation(.default, value: self.credentials.isPasswordValid(self.credentials.password))
        .animation(.default, value: self.credentials.passwordsMatch())
        .alert("An error occurred", isPresented: self.$showErrorAlert) {
            // nothing to show
        } message: {
            Text(self.authManager.errorMessage)
        }
        .onReceive(self.authManager.$showErrorAlert) { newValue in
            self.showErrorAlert = newValue
        }
    }

    // MARK: Private

    @State private var credentials = CompanyCredentialsViewModel.shared
    @State private var showErrorAlert = false

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("email", text: self.$credentials.mail)
                .textFieldStyle(.roundedBorder)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
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
                .textContentType(.newPassword)
            if !self.credentials.password.isEmpty,
               !self.credentials.isPasswordValid(self.credentials.password)
            {
                Text(self.credentials.invalidPasswordText)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var confirmPasswordField: some View {
        VStack(alignment: .leading, spacing: 10) {
            SecureField("confirm password", text: self.$credentials.confirmPassword)
                .textFieldStyle(.roundedBorder)
                .textContentType(.password)
            if !self.credentials.password.isEmpty,
               !self.credentials.confirmPassword.isEmpty,
               !self.credentials.passwordsMatch()
            {
                Text(self.credentials.invalidConfirmPasswordText)
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
                self.authManager.signUp(
                    email: self.credentials.mail,
                    password: self.credentials.password
                )
            },
            label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
            }
        )
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .disabled(!self.credentials.signUpIsComplete)
        .animation(.default, value: self.credentials.signUpIsComplete)
    }
}

#Preview {
    SignupView()
        .environmentObject(AuthManager())
}
