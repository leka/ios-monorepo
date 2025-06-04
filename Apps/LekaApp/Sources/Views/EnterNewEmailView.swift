// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import LocalizationKit
import SwiftUI

struct EnterNewEmailView: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 30) {
            Text(l10n.EnterNewEmailView.title)
                .font(.title)

            TextFieldEmail(entry: self.$newEmail)
                .frame(width: 400)

            Button {
                self.submit()
            } label: {
                Text(l10n.EnterNewEmailView.confirmButton)
                    .loadingIndicator(isLoading: self.authManagerVM.isLoading)
            }
            .disabled(self.isSubmissionDisabled)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .alert(isPresented: self.$showVerificationAlert) {
            Alert(
                title: Text(l10n.AccountCreationView.EmailVerificationAlert.title),
                message: Text(l10n.AccountCreationView.EmailVerificationAlert.message),
                dismissButton: .default(Text(l10n.AccountCreationView.EmailVerificationAlert.dismissButton)) {
                    self.authManagerVM.setUserAction(.none)
                    self.dismiss()
                }
            )
        }
    }

    // MARK: Private

    @State private var newEmail: String = ""
    @State private var showVerificationAlert = false

    private var authManagerVM = AuthManagerViewModel.shared
    private var authManager = AuthManager.shared

    private var isSubmissionDisabled: Bool {
        self.newEmail.isInvalidEmail()
    }

    private func submit() {
        guard !self.isSubmissionDisabled else { return }

        self.authManager.sendEmailVerificationBeforeUpdatingEmail(to: self.newEmail)

        self.showVerificationAlert = true
    }
}
