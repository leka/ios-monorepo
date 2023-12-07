// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AuthenticationServices
import SwiftUI

struct SignupView: View {
    // MARK: Internal

    @EnvironmentObject var authenticationState: OrganisationAuthState

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
        .animation(.default, value: self.organisation.isEmailValid())
        .animation(.default, value: self.organisation.isPasswordValid(self.organisation.password))
        .animation(.default, value: self.organisation.passwordsMatch())
    }

    // MARK: Private

    @State private var organisation = OrganisationViewModel()

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("email", text: self.$organisation.mail)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            if !self.organisation.mail.isEmpty,
               !self.organisation.isEmailValid()
            {
                Text(self.organisation.invalidEmailAddressText)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 10) {
            SecureField("password", text: self.$organisation.password)
                .textFieldStyle(.roundedBorder)
            if !self.organisation.password.isEmpty,
               !self.organisation.isPasswordValid(self.organisation.password)
            {
                Text(self.organisation.invalidPasswordText)
                    .font(.footnote)
                    .lineLimit(2)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var confirmPasswordField: some View {
        VStack(alignment: .leading, spacing: 10) {
            SecureField("confirm password", text: self.$organisation.confirmPassword)
                .textFieldStyle(.roundedBorder)
            if !self.organisation.password.isEmpty,
               !self.organisation.confirmPassword.isEmpty,
               !self.organisation.passwordsMatch()
            {
                Text(self.organisation.invalidConfirmPasswordText)
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
                self.authenticationState.organisationIsAuthenticated = .loggedIn // tests
            },
            label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
            }
        )
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .disabled(!self.organisation.signUpIsComplete)
        .animation(.default, value: self.organisation.signUpIsComplete)
    }
}

#Preview {
    SignupView()
        .environmentObject(OrganisationAuthState())
}
