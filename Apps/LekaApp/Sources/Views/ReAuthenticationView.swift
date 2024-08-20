// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import LocalizationKit
import SwiftUI

// MARK: - ReAuthenticationView

struct ReAuthenticationView: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(spacing: 10) {
                VStack(spacing: 40) {
                    Text(l10n.ReAuthenticationView.title)
                        .font(.title)

                    Text(l10n.ReAuthenticationView.contextMessage)
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
                    Button(
                        String(l10n.ReAuthenticationView.resetPasswordButtonLabel.characters),
                        role: .destructive
                    ) {
                        self.authManager.sendPasswordResetEmail(to: self.authManager.currentUserEmail ?? "")
                        self.showConfirmResetPassword = false
                        self.dismiss()
                    }
                    Button(
                        String(l10n.ReAuthenticationView.cancelResetPasswordButtonLabel.characters),
                        role: .cancel
                    ) {
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
                Text(String(l10n.ReAuthenticationView.reauthAndDeleteAccountButton.characters))
                    .loadingIndicator(isLoading: self.authManagerViewModel.isLoading)
            }
            .disabled(self.isConnectionDisabled || self.authManagerViewModel.isLoading)
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        // [] TODO: (@team) - Move to iOS17 support - Update the use of .onChange() modifier.
        // See below
        // .onChange(of: self.authManagerViewModel.reAuthenticationSucceeded, initial: false) { oldValue, newValue in
        //     if newValue { self.dismiss() }
        // }
        .onChange(of: self.authManagerViewModel.reAuthenticationSucceeded) { success in
            if success {
                self.dismiss()
            }
        }
    }

    // MARK: Private

    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    @State private var password: String = ""
    @State private var showConfirmResetPassword: Bool = false

    private var authManager: AuthManager = .shared

    private var isConnectionDisabled: Bool {
        self.password.isEmpty
    }

    private func submitForm() {
        self.authManager.reAuthenticateCurrentUser(password: self.password)
    }
}

#Preview {
    Text("Hello, World!")
        .sheet(isPresented: .constant(true)) {
            ReAuthenticationView()
        }
}
