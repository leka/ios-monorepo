// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AuthenticationServices
import SwiftUI

struct LoginView: View {
    // MARK: Internal

    @EnvironmentObject var authenticationState: OrganisationAuthState

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
        .animation(.default, value: self.organisation.isEmailValid())
        .animation(.default, value: self.organisation.isPasswordValid(self.organisation.password))
        .sheet(isPresented: self.$showSheet) { ForgotPasswordView() }
    }

    // MARK: Private

    @State private var organisation = OrganisationViewModel()
    @State private var showSheet: Bool = false

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
        .padding(.bottom, 10)
    }

    private var loginButton: some View {
        Button(
            action: {
                self.authenticationState.organisationIsAuthenticated = .loggedIn // tests
            },
            label: {
                Text("Log In")
                    .frame(maxWidth: .infinity)
            }
        )
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .disabled(!self.organisation.logInIsComplete)
        .animation(.default, value: self.organisation.logInIsComplete)
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
        .environmentObject(OrganisationAuthState())
}
