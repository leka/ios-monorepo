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
            emailField
            passwordField
            confirmPasswordField
            signupButton
        }
        .textInputAutocapitalization(.never)
        .frame(maxWidth: 400)
        .padding()
        .navigationTitle("Sign-Up View")
        .navigationBarTitleDisplayMode(.large)
        .animation(.default, value: organisation.isEmailValid())
        .animation(.default, value: organisation.isPasswordValid(organisation.password))
        .animation(.default, value: organisation.passwordsMatch())
    }

    // MARK: Private

    @State private var organisation = OrganisationViewModel()

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("email", text: $organisation.mail)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            if !organisation.mail.isEmpty,
               !organisation.isEmailValid() {
                Text(organisation.invalidEmailAddressText)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 10) {
            SecureField("password", text: $organisation.password)
                .textFieldStyle(.roundedBorder)
            if !organisation.password.isEmpty,
               !organisation.isPasswordValid(organisation.password) {
                Text(organisation.invalidPasswordText)
                    .font(.footnote)
                    .lineLimit(2)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 10)
            }
        }
    }

    private var confirmPasswordField: some View {
        VStack(alignment: .leading, spacing: 10) {
            SecureField("confirm password", text: $organisation.confirmPassword)
                .textFieldStyle(.roundedBorder)
            if !organisation.password.isEmpty,
               !organisation.confirmPassword.isEmpty,
               !organisation.passwordsMatch() {
                Text(organisation.invalidConfirmPasswordText)
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
                authenticationState.organisationIsAuthenticated = .loggedIn // tests
            },
            label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
            }
        )
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .disabled(!organisation.signUpIsComplete)
        .animation(.default, value: organisation.signUpIsComplete)
    }
}

#Preview {
    SignupView()
        .environmentObject(OrganisationAuthState())
}
