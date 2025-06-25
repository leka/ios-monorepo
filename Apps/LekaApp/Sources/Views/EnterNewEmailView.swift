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
            Image(systemName: "envelope")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)

            Text(l10n.EnterNewEmailView.title)
                .font(.title)

            Text(l10n.EnterNewEmailView.contextMessage)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

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
        .sheet(isPresented: self.$showConfirmChangeEmailView, onDismiss: {
            guard self.authManagerVM.reAuthenticationSucceeded else {
                self.dismiss()
                return
            }
            self.authManager.sendEmailVerificationBeforeUpdatingEmail(to: self.newEmail)
        }, content: {
            ConfirmChangeEmailView()
        })
        .alert(String(l10n.AccountCreationView.EmailVerificationAlert.title.characters),
               isPresented: self.$showChangeEmailSuccessAlert)
        {
            Button(String(l10n.AccountCreationView.EmailVerificationAlert.dismissButton.characters), role: .cancel) {
                self.authManagerVM.setUserAction(.none)
                self.dismiss()
            }
        } message: {
            Text(l10n.AccountCreationView.EmailVerificationAlert.message)
        }
        .alert(String(l10n.EnterNewEmailView.changeEmailFailureAlertTitle.characters),
               isPresented: self.$showChangeEmailFailureAlert)
        {
            Button(String(l10n.EnterNewEmailView.changeEmailFailureAlertDismissButton.characters), role: .cancel) {
                self.authManagerVM.setUserAction(.none)
                self.dismiss()
            }
        } message: {
            Text(l10n.EnterNewEmailView.changeEmailFailureAlertMessage)
        }
        .onReceive(self.authManager.sendEmailUpdatePublisher) { success in
            if success {
                self.showChangeEmailSuccessAlert = true
            } else {
                self.showChangeEmailFailureAlert = true
            }
        }
    }

    // MARK: Private

    @State private var newEmail: String = ""
    @State private var showConfirmChangeEmailView = false
    @State private var showChangeEmailSuccessAlert = false
    @State private var showChangeEmailFailureAlert = false

    private var authManagerVM = AuthManagerViewModel.shared
    private var authManager = AuthManager.shared

    private var isSubmissionDisabled: Bool {
        self.newEmail.isInvalidEmail()
    }

    private func submit() {
        self.showConfirmChangeEmailView = true
    }
}
