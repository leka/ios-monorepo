// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ConnectionViewViewModel

// ? Make sure you have set up Associated Domains for your app and AutoFill Passwords
// ? is enabled in Settings in order to get the strong password proposals etc...
// ? the same applies for both login/signup
// ? re-enable autofill modifiers in TextFields when OK (textContentType)

class ConnectionViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
}

// MARK: - ConnectionView

struct ConnectionView: View {
    // MARK: Internal

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(spacing: 10) {
                Text(l10n.ConnectionView.title)
                    .font(.title)

                Text(self.authManagerViewModel.errorMessage)
                    .font(.footnote)
                    .foregroundStyle(self.authManagerViewModel.showErrorAlert ? .red : .clear)
            }

            VStack {
                TextFieldEmail(entry: self.$viewModel.email)

                VStack {
                    TextFieldPassword(entry: self.$viewModel.password)

                    Text(l10n.ConnectionView.passwordForgottenButton)
                        .font(.footnote)
                        .underline()
                }
            }
            .disableAutocorrection(true)
            .frame(width: 350)

            Button {
                self.submitForm()
            } label: {
                Text(String(l10n.ConnectionView.connectionButton.characters))
                    .loadingText(isLoading: self.authManagerViewModel.isLoading)
            }
            .disabled(self.isConnectionDisabled || self.authManagerViewModel.isLoading)
            .buttonStyle(.borderedProminent)
        }
        .onChange(of: self.authManagerViewModel.userAuthenticationState) { newValue in
            if newValue == .loggedIn {
                self.caregiverManager.initializeCaregiversListener()
                self.carereceiverManager.initializeCarereceiversListener()
                self.authManagerViewModel.userAction = .none
                self.navigation.fullScreenCoverContent = nil
            }
        }
        .onAppear {
            self.authManagerViewModel.userAction = .userIsSigningIn
        }
        .onDisappear {
            self.authManagerViewModel.resetErrorMessage()
            self.navigation.sheetContent = .caregiverPicker
        }
    }

    // MARK: Private

    @StateObject private var viewModel = ConnectionViewViewModel()
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservedObject private var navigation: Navigation = .shared

    private var authManager: AuthManager = .shared
    private var caregiverManager: CaregiverManager = .shared
    private var carereceiverManager: CarereceiverManager = .shared

    private var isConnectionDisabled: Bool {
        self.viewModel.email.isEmpty || self.viewModel.password.isEmpty
    }

    private func submitForm() {
        self.authManager.signIn(email: self.viewModel.email, password: self.viewModel.password)
    }
}

#Preview {
    ConnectionView()
}
