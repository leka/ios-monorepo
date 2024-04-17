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

                Text(self.authManagerViewModel.errorMessage)
                    .font(.footnote)
                    .foregroundStyle(self.authManagerViewModel.showErrorMessage ? .red : .clear)
            }

            VStack {
                TextFieldPassword(entry: self.$password)

                Button(role: .destructive) {
                    self.showForgotPassword = true
                } label: {
                    Text(l10n.ReAuthenticationView.passwordForgottenButton)
                        .font(.footnote)
                        .underline()
                }
                .alert(
                    String(l10n.ReAuthenticationView.alertTitle.characters),
                    isPresented: self.$showForgotPassword
                ) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(l10n.ReAuthenticationView.alertMessage)
                }
            }
            .disableAutocorrection(true)
            .frame(width: 350)

            Button {
                self.submitForm()
            } label: {
                Text(String(l10n.ReAuthenticationView.connectionButton.characters))
                    .loadingIndicator(isLoading: self.authManagerViewModel.isLoading)
            }
            .disabled(self.isConnectionDisabled || self.authManagerViewModel.isLoading)
            .buttonStyle(.borderedProminent)
        }
        .onChange(of: self.authManagerViewModel.reAuthenticationSucceeded) { success in
            if success {
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
    @State private var showForgotPassword: Bool = false

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
