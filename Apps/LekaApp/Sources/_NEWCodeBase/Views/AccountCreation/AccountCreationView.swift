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
    @Published var navigateToAccountCreationProcess: Bool = false
}

// MARK: - AccountCreationView

struct AccountCreationView: View {
    // MARK: Internal

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text(l10n.AccountCreationView.createAccountTitle)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.title)

            VStack(spacing: 15) {
                TextFieldEmail(entry: self.$viewModel.email)
                TextFieldPassword(entry: self.$viewModel.password)
            }
            .frame(width: 400)
            .disableAutocorrection(true)

            Button(String(l10n.AccountCreationView.connectionButton.characters)) {
                self.submitForm()
            }
            .disabled(self.isCreationDisabled)
            .buttonStyle(.borderedProminent)
        }
        .navigationDestination(isPresented: self.$viewModel.navigateToAccountCreationProcess) {
            AccountCreationProcess.Step1()
        }
    }

    // MARK: Private

    @StateObject private var viewModel = AccountCreationViewViewModel()

    private var isCreationDisabled: Bool {
        !self.viewModel.email.isValidEmail() || self.viewModel.email.isEmpty || self.viewModel.password.isEmpty
    }

    private func submitForm() {
        // TODO: (@team) - Assert that credentials are valids
        self.viewModel.navigateToAccountCreationProcess.toggle()
    }
}

// MARK: - AccountCreationView_Previews

#Preview {
    AccountCreationView()
}