// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AuthenticationServices
import SwiftUI

struct LoginView: View {

    @EnvironmentObject var authenticationState: OrganisationAuthState
    @State private var organisation = OrganisationViewModel()
    @State private var showSheet: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            emailField
            passwordField
            loginButton
            forgotLink
        }
        .textInputAutocapitalization(.never)
        .frame(maxWidth: 400)
        .padding()
        .navigationTitle("Login View")
        .navigationBarTitleDisplayMode(.large)
        .animation(.default, value: organisation.isEmailValid())
        .animation(.default, value: organisation.isPasswordValid(organisation.password))
        .sheet(isPresented: $showSheet) { ForgotPasswordView() }
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("email", text: $organisation.mail)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            if !organisation.mail.isEmpty
                && !organisation.isEmailValid()
            {
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
            if !organisation.password.isEmpty
                && !organisation.isPasswordValid(organisation.password)
            {
                Text(organisation.invalidPasswordText)
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
                authenticationState.organisationIsAuthenticated = .loggedIn  // tests
            },
            label: {
                Text("Log In")
                    .frame(maxWidth: .infinity)
            }
        )
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .disabled(!organisation.logInIsComplete)
        .animation(.default, value: organisation.logInIsComplete)
    }

    private var forgotLink: some View {
        HStack {
            Spacer()
            Button(
                action: {
                    showSheet = true
                },
                label: {
                    Text("Forgot Password")
                        .font(.footnote)
                        .underline()
                        .padding(.trailing, 10)
                })
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(OrganisationAuthState())
}
