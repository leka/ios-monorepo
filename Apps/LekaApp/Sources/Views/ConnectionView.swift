// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ConnectionViewViewModel

// ? Make sure you have set up Associated Domains for your app and AutoFill Passwords
// ? is enabled in Settings in order to get the strong password proposals etc...
// ? the same applies for both login/signup
// ? re-enable autofill modifiers in TextFields when OK (textContentType)

// MARK: - ConnectionView

struct ConnectionView: View {
    // MARK: Internal

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 30) {
                VStack(spacing: 10) {
                    Text(l10n.ConnectionView.title)
                        .font(.title)

                    Text(l10n.ConnectionView.signInFailedError)
                        .font(.footnote)
                        .foregroundStyle(self.authManagerViewModel.showErrorMessage ? .red : .clear)
                }

                VStack {
                    TextFieldEmail(entry: self.$email)

                    VStack {
                        TextFieldPassword(entry: self.$password)

                        Button(role: .destructive) {
                            self.showResetPassword = true
                            self.authManagerViewModel.setUserAction(.userIsResettingPassword)
                        } label: {
                            Text(l10n.ConnectionView.passwordForgottenButton)
                                .font(.footnote)
                                .underline()
                        }
                        .sheet(isPresented: self.$showResetPassword) {
                            self.authManagerViewModel.setUserAction(.userIsSigningIn)
                        } content: {
                            ForgotPasswordView(email: self.email)
                        }
                    }
                }
                .disableAutocorrection(true)
                .frame(width: 350)

                Button {
                    self.submitForm()
                } label: {
                    Text(String(l10n.ConnectionView.connectionButton.characters))
                        .loadingIndicator(
                            isLoading: self.authManagerViewModel.isLoading,
                            forceWhiteTint: true
                        )
                }
                .disabled(self.isConnectionDisabled || self.authManagerViewModel.isLoading)
                .buttonStyle(.borderedProminent)
            }
            .onChange(of: self.authManagerViewModel.userAuthenticationState) { newValue in
                if newValue == .loggedIn {
                    self.caregiverManager.initializeCaregiversListener()
                    self.carereceiverManager.initializeCarereceiversListener()
                    self.rootAccountManager.initializeRootAccountListener()
                    self.libraryManager.initializeLibraryListener()
                    AnalyticsManager.logEventLogin()
                    self.navigation.setFullScreenCoverContent(nil)
                    self.authManagerViewModel.setUserAction(.none)
                }
            }
            .onAppear {
                self.authManagerViewModel.setUserAction(.none)
            }
            .onDisappear {
                self.authManagerViewModel.resetErrorMessage()
            }
        }
    }

    // MARK: Private

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var forgotPasswordEmail: String = ""

    @State private var showResetPassword: Bool = false

    private var navigation: Navigation = .shared
    private var authManager: AuthManager = .shared
    private var authManagerViewModel: AuthManagerViewModel = .shared
    private var rootAccountManager: RootAccountManager = .shared
    private var libraryManager: LibraryManager = .shared
    private var caregiverManager: CaregiverManager = .shared
    private var carereceiverManager: CarereceiverManager = .shared

    private var isConnectionDisabled: Bool {
        self.email.isEmpty || self.password.isEmpty
    }

    private func submitForm() {
        self.authManager.signIn(email: self.email, password: self.password)
    }
}

#Preview {
    ConnectionView()
}
