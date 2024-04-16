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
                    Text("Account Deletion")
                        .font(.title)

                    Text("""
                        Once you delete your account, there is no going back. All your data will be deleted forever. Please be certain.
                        You need to re-authenticate using your password to delete your account.
                        """)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                }

                Text(self.authManagerViewModel.errorMessage)
                    .font(.footnote)
                    .foregroundStyle(self.authManagerViewModel.showErrorMessage ? .red : .clear)
            }

            VStack {
                TextFieldPassword(entry: self.$password)

                Text(l10n.ConnectionView.passwordForgottenButton)
                    .font(.footnote)
                    .underline()
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
        .onChange(of: self.authManagerViewModel.reAuthenticationSucceeded) { success in
            if success {
                self.authManagerViewModel.userAction = .none
                self.dismiss()
            }
        }
        .onDisappear {
            self.authManagerViewModel.resetErrorMessage()
        }
    }

    // MARK: Private

    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    @State private var password: String = ""

    private var authManager: AuthManager = .shared

    private var isConnectionDisabled: Bool {
        // TODO(@macteuts): Complete disabling conditions
        self.password.isEmpty
    }

    private func submitForm() {
        self.authManager.reAuthenticateCurrentUser(password: self.password)
    }
}

#Preview {
    ReAuthenticationView()
}
