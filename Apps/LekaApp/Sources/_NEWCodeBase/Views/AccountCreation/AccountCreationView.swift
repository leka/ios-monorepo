// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - AccountCreationViewViewModel

class AccountCreationViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirm: String = ""
    @Published var isEditing = false

    @Published var navigateToStep1: Bool = false
}

// MARK: - AccountCreationView

struct AccountCreationView: View {
    // MARK: Internal

    struct NavigationTitle: View {
        var body: some View {
            Text(l10n.AccountCreationView.navigationTitle)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.headline)
        }
    }

    @FocusState var focusedField: FormField?

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text(l10n.AccountCreationView.createAccountTitle)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.title)

            Group {
                self.mailTextField
                self.passwordTextField
                self.confirmTextField
            }
            .frame(width: 400)
            .onAppear { self.focusedField = .mail }
            .disableAutocorrection(true)

            Button(String(l10n.AccountCreationView.connectionButton.characters)) {
                self.submitForm()
            }
            .disabled(self.connectIsDisabled())
            .buttonStyle(.borderedProminent)
        }
        .navigationDestination(isPresented: self.$viewModel.navigateToStep1) {
            Step1()
        }
    }

    func connectIsDisabled() -> Bool {
        !self.viewModel.email.isValidEmail() || !self.passwordsMatch() || self.viewModel.email.isEmpty || self.viewModel.password.isEmpty || self.viewModel.confirm.isEmpty
    }

    func passwordsMatch() -> Bool {
        self.viewModel.password == self.viewModel.confirm
    }

    // MARK: Private

    @StateObject private var viewModel = AccountCreationViewViewModel()

    @ViewBuilder
    private var mailTextField: some View {
        MailTextField(
            label: String(l10n.AccountCreationView.emailLabel.characters),
            entry: self.$viewModel.email,
            focused: _focusedField
        ) {
            self.focusedField = .password
        }
    }

    @ViewBuilder
    private var passwordTextField: some View {
        PasswordTextField(
            label: String(l10n.AccountCreationView.passwordLabel.characters),
            type: .password,
            entry: self.$viewModel.password,
            focused: _focusedField
        ) {
            if !self.viewModel.password.isEmpty {
                self.focusedField = .confirm
            } else {
                self.focusedField = .password
            }
        }
    }

    @ViewBuilder
    private var confirmTextField: some View {
        PasswordTextField(
            label: String(l10n.AccountCreationView.confirmLabel.characters),
            type: .confirm,
            entry: self.$viewModel.confirm,
            focused: _focusedField
        ) {
            if self.viewModel.confirm.isEmpty || !self.passwordsMatch() {
                self.focusedField = .confirm
            } else {
                self.submitForm()
            }
        }
    }

    private func submitForm() {
        // TODO: (@team) - Assert that credentials are valids
        self.viewModel.navigateToStep1.toggle()
    }
}

// MARK: - AccountCreationView_Previews

#Preview {
    AccountCreationView()
}
