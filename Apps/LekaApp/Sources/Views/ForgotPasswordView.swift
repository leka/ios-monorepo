// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import LocalizationKit
import SwiftUI

// MARK: - ReAuthenticationView

struct ForgotPasswordView: View {
    // MARK: Lifecycle

    init(email: String) {
        self._email = State(initialValue: email)
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    @State var email: String

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(spacing: 40) {
                Text(l10n.ForgotPasswordView.title)
                    .font(.title)

                Text(l10n.ForgotPasswordView.contextMessage)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            TextFieldEmail(entry: self.$email)
                .disableAutocorrection(true)
                .frame(width: 350)

            Button {
                self.submitForm()
            } label: {
                Text(String(l10n.ForgotPasswordView.resetPasswordButtonLabel.characters))
                    .loadingIndicator(isLoading: self.authManagerViewModel.isLoading)
            }
            .disabled(self.isResetButtonDisabled || self.authManagerViewModel.isLoading)
            .buttonStyle(.borderedProminent)
        }
        .alert(String(l10n.ForgotPasswordView.successAlertTitle.characters),
               isPresented: self.$authManagerViewModel.resetPasswordSucceeded)
        {
            Button("OK", role: .cancel) {
                self.authManagerViewModel.userAction = .none
                self.dismiss()
            }
        } message: {
            Text(String(l10n.ForgotPasswordView.successAlertMessage.characters))
        }
        .alert(String(l10n.ForgotPasswordView.errorAlertTitle.characters),
               isPresented: self.$authManagerViewModel.showErrorAlert)
        {
            Button("OK", role: .cancel) {}
        } message: {
            Text(String(l10n.ForgotPasswordView.errorAlertMessage.characters))
        }
    }

    // MARK: Private

    @Bindable private var authManagerViewModel: AuthManagerViewModel = .shared

    private var authManager: AuthManager = .shared

    private var isResetButtonDisabled: Bool {
        self.email.isInvalidEmail()
    }

    private func submitForm() {
        self.authManager.sendPasswordResetEmail(to: self.email)
    }
}

#Preview {
    ReAuthenticationView()
}
