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

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(spacing: 10) {
                Text(l10n.AccountCreationView.createAccountTitle)
                    .font(.title)

                Text(self.authManagerViewModel.errorMessage)
                    .font(.footnote)
                    .foregroundStyle(self.authManagerViewModel.showErrorAlert ? .red : .clear)
            }

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
        .onChange(of: self.authManagerViewModel.userAuthenticationState) { newValue in
            if newValue == .loggedIn {
                self.authManagerViewModel.userIsSigningUp = true
                self.rootOwnerViewModel.currentCompany = Company(
                    email: self.viewModel.email,
                    password: self.viewModel.password
                )
                self.viewModel.navigateToAccountCreationProcess.toggle()
            } else {
                // display signup failed alert
            }
        }
    }

    // MARK: Private

    @StateObject private var viewModel = AccountCreationViewViewModel()
    @ObservedObject private var rootOwnerViewModel = RootOwnerViewModel.shared
    @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
    private var authManager = AuthManager.shared

    private var isCreationDisabled: Bool {
        self.viewModel.email.isInvalidEmail() || self.viewModel.password.isInvalidPassword()
    }

    private func submitForm() {
        self.authManager.signUp(email: self.viewModel.email, password: self.viewModel.password)
    }
}

// MARK: - AccountCreationView_Previews

#Preview {
    AccountCreationView()
}
