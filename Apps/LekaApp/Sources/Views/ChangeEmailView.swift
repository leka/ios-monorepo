// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import LocalizationKit
import SwiftUI

// MARK: - ChangeEmailView

struct ChangeEmailView: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(spacing: 10) {
                VStack(spacing: 40) {
                    Text(l10n.ChangeEmailView.title)
                        .font(.title)

                    Text(l10n.ChangeEmailView.contextMessage)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }

                Text(l10n.ReAuthenticationView.reAuthenticationFailedError)
                    .font(.footnote)
                    .foregroundStyle(self.authManagerViewModel.showErrorMessage ? .red : .clear)
            }

            VStack {
                TextFieldPassword(entry: self.$password)

                Button {
                    self.showConfirmResetPassword = true
                    self.authManagerViewModel.userAction = .userIsResettingPassword
                } label: {
                    Text(l10n.ReAuthenticationView.passwordForgottenButton)
                        .font(.footnote)
                        .underline()
                }
                .alert(String(l10n.ReAuthenticationView.confirmResetPasswordAlertTitle.characters),
                       isPresented: self.$showConfirmResetPassword)
                {
                    Button(String(l10n.ReAuthenticationView.resetPasswordButtonLabel.characters), role: .destructive) {
                        self.authManager.sendPasswordResetEmail(to: self.authManager.currentUserEmail ?? "")
                        self.showConfirmResetPassword = false
                        self.dismiss()
                    }

                    Button(String(l10n.ReAuthenticationView.cancelResetPasswordButtonLabel.characters), role: .cancel) {
                        self.authManagerViewModel.userAction = .userIsReAuthenticating
                    }
                } message: {
                    Text(l10n.ReAuthenticationView.confirmResetPasswordAlertMessage)
                }
            }
            .disableAutocorrection(true)
            .frame(width: 350)

            Button {
                self.submitForm()
            } label: {
                Text(String(l10n.ChangeEmailView.reauthAndChangeEmailButton.characters))
                    .loadingIndicator(isLoading: self.authManagerViewModel.isLoading)
            }
            .disabled(self.password.isEmpty || self.authManagerViewModel.isLoading)
            .buttonStyle(.borderedProminent)
        }
        .onChange(of: self.authManagerViewModel.reAuthenticationSucceeded) { _, newValue in
            if newValue {
                self.showEnterNewEmailSheet = true
                self.authManagerViewModel.userAction = .userIsChangingEmail
            }
        }
        .sheet(isPresented: self.$showEnterNewEmailSheet) {
            Text("Enter your new email address")
        }
    }

    // MARK: Private

    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @State private var password: String = ""
    @State private var showConfirmResetPassword: Bool = false
    @State private var showEnterNewEmailSheet: Bool = false

    private let authManager = AuthManager.shared

    private func submitForm() {
        self.authManager.reAuthenticateCurrentUser(password: self.password)
    }
}
