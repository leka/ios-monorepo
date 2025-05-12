// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - AccountCreationView

struct AccountCreationView: View {
    // MARK: Internal

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(spacing: 10) {
                Text(l10n.AccountCreationView.createAccountTitle)
                    .font(.title)

                Text(l10n.AccountCreationView.signupFailedError)
                    .font(.footnote)
                    .foregroundStyle(self.authManagerViewModel.showErrorMessage ? .red : .clear)
            }

            VStack(spacing: 15) {
                TextFieldEmail(entry: self.$email)
                TextFieldPassword(entry: self.$password)
            }
            .frame(width: 400)
            .disableAutocorrection(true)

            Button {
                self.submitForm()
            } label: {
                Text(String(l10n.AccountCreationView.connectionButton.characters))
                    .loadingIndicator(
                        isLoading: self.authManagerViewModel.isLoading,
                        forceWhiteTint: true
                    )
            }
            .disabled(self.isCreationDisabled || self.authManagerViewModel.isLoading)
            .buttonStyle(.borderedProminent)
        }
        .onChange(of: self.authManagerViewModel.userAuthenticationState) { newValue in
            if newValue == .loggedIn {
                self.rootAccountManager.createRootAccount(rootAccount: RootAccount())
                self.rootAccountManager.initializeRootAccountListener()
                self.libraryManager.createLibrary(library: Library())
                self.libraryManager.initializeLibraryListener()
                self.isVerificationEmailAlertPresented = true
            }
        }
        .onAppear {
            self.authManagerViewModel.userAction = .userIsSigningUp
        }
        .onDisappear {
            self.authManagerViewModel.resetErrorMessage()
        }
        .alert(isPresented: self.$isVerificationEmailAlertPresented) {
            Alert(title: Text(l10n.AccountCreationView.EmailVerificationAlert.title),
                  message: Text(l10n.AccountCreationView.EmailVerificationAlert.message),
                  dismissButton: .default(Text(l10n.AccountCreationView.EmailVerificationAlert.dismissButton)) {
                      AnalyticsManager.logEventSignUp()
                      self.navigation.navigateToAccountCreationProcess = true
                  })
        }
    }

    // MARK: Private

    @State private var email: String = ""
    @State private var password: String = ""

    @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
    @ObservedObject private var navigation: Navigation = .shared

    @State private var isVerificationEmailAlertPresented: Bool = false

    private var authManager = AuthManager.shared
    private var rootAccountManager = RootAccountManager.shared
    private var libraryManager = LibraryManager.shared

    private var isCreationDisabled: Bool {
        self.email.isInvalidEmail() || self.password.isInvalidPassword()
    }

    private func submitForm() {
        self.authManager.signUp(email: self.email, password: self.password)
    }
}

// MARK: - AccountCreationView_Previews

#Preview {
    AccountCreationView()
}
