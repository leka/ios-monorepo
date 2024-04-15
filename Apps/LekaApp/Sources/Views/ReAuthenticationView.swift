// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import LocalizationKit
import SwiftUI

// MARK: - ReAuthenticationView

struct ReAuthenticationView: View {
    // MARK: Internal

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(spacing: 10) {
                Text("Password confirmation")
                    .font(.title)

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
