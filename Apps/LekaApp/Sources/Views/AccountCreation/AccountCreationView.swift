// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - AccountCreationViewViewModel

class AccountCreationViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
}

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
                TextFieldEmail(entry: self.$viewModel.email)
                TextFieldPassword(entry: self.$viewModel.password)
            }
            .frame(width: 400)
            .disableAutocorrection(true)

            Button {
                self.showConsentView = true
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
                let rootAccount = RootAccount(consentInfo: [self.userConsentInfo!])
                self.rootAccountManager.createRootAccount(rootAccount: rootAccount)
                self.rootAccountManager.initializeRootAccountListener()
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
        .sheet(isPresented: self.$showConsentView) {
            ConsentView(
                onCancel: {
                    self.showConsentView = false
                },
                onAccept: {
                    self.userConsentInfo = ConsentInfo(policyVersion: "1.0.0")
                    self.showConsentView = false
                    self.submitForm()
                }
            )
        }
    }

    // MARK: Private

    @StateObject private var viewModel = AccountCreationViewViewModel()

    @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
    @ObservedObject private var navigation: Navigation = .shared

    @State private var isVerificationEmailAlertPresented: Bool = false
    @State private var showConsentView: Bool = false
    @State private var userConsentInfo: ConsentInfo?

    private var authManager = AuthManager.shared
    private var rootAccountManager = RootAccountManager.shared

    private var isCreationDisabled: Bool {
        self.viewModel.email.isInvalidEmail() || self.viewModel.password.isInvalidPassword()
    }

    private func submitForm() {
        self.authManager.signUp(email: self.viewModel.email, password: self.viewModel.password)
    }
}

// MARK: - AccountCreationView_Previews

#Preview {
    AccountCreationView()
}
