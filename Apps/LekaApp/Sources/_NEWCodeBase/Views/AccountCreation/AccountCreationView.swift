// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
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

    @EnvironmentObject var authManager: AuthManager

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
            AccountCreationProcess.CarouselView()
                .navigationBarBackButtonHidden()
        }
    }

    // MARK: Private

    @StateObject private var viewModel = AccountCreationViewViewModel()
    @ObservedObject var rootViewModelViewModel = RootOwnerViewModel.shared

    private var isCreationDisabled: Bool {
        self.viewModel.email.isInvalidEmail() || self.viewModel.password.isInvalidPassword()
    }

    private func submitForm() {
        self.authManager.signUp(
            email: self.viewModel.email,
            password: self.viewModel.password
        )

        if self.authManager.userIsSigningUp {
            self.rootViewModelViewModel.currentCompany.email = self.viewModel.email
            self.rootViewModelViewModel.currentCompany.password = self.viewModel.password
            self.viewModel.navigateToAccountCreationProcess.toggle()
        }
    }
}

// MARK: - AccountCreationView_Previews

#Preview {
    AccountCreationView(rootViewModelViewModel: RootOwnerViewModel.shared)
        .environmentObject(AuthManager())
}
