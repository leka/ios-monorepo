// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ConnectionViewViewModel

// ? Make sure you have set up Associated Domains for your app and AutoFill Passwords
// ? is enabled in Settings in order to get the strong password proposals etc...
// ? the same applies for both login/signup
// ? re-enable autofill modifiers in TextFields when OK (textContentType)

class ConnectionViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var navigateToCaregiverSelection: Bool = false
}

// MARK: - ConnectionView

struct ConnectionView: View {
    // MARK: Internal

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text(l10n.ConnectionView.title)
                .font(.title) // TODO: (@ui/ux) - Design System - replace with Leka font

            VStack {
                TextFieldEmail(entry: self.$viewModel.email)

                VStack {
                    TextFieldPassword(entry: self.$viewModel.password)

                    Text(l10n.ConnectionView.passwordForgottenButton)
                        .font(.footnote) // TODO: (@ui/ux) - Design System - replace with Leka font
                        .underline()
                }
            }
            .disableAutocorrection(true)
            .frame(width: 350)

            Button(String(l10n.ConnectionView.connectionButton.characters)) {
                self.submitForm()
            }
            .disabled(self.isConnectionDisabled)
            .buttonStyle(.borderedProminent)
        }
        .navigationDestination(isPresented: self.$viewModel.navigateToCaregiverSelection) {
            // TODO: (@release) - Implement selection + review nav destination use
            CaregiverPicker()
        }
    }

    // MARK: Private

    @StateObject private var viewModel = ConnectionViewViewModel()
    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared

    private var isConnectionDisabled: Bool {
        self.viewModel.email.isEmpty || self.viewModel.password.isEmpty
    }

    private func submitForm() {
        // TODO: (@release) - Plug to AccountKit
        self.rootOwnerViewModel.currentCompany = Company(email: self.viewModel.email, password: self.viewModel.password)
        self.viewModel.navigateToCaregiverSelection.toggle()
    }
}

#Preview {
    ConnectionView()
}
