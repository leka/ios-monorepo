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
// ? re-enable autofill modifiers in LekaTextField when OK (textContentType)

class ConnectionViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isEditing = false

    @Published var credentialsAreCorrect: Bool = true

    @Published var navigateToTeacherSelector: Bool = false
}

// MARK: - ConnectionView

struct ConnectionView: View {
    // MARK: Internal

    @FocusState var focusedField: FormField?

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text(l10n.ConnectionView.title)
                .font(.title) // TODO: (@ui/ux) - Design System - replace with Leka font

            Group {
                self.mailTextField

                VStack(spacing: 0) {
                    self.passwordTextField

                    Text(l10n.ConnectionView.passwordForgottenButton)
                        .font(.footnote) // TODO: (@ui/ux) - Design System - replace with Leka font
                        .underline()
                }
            }
            .disableAutocorrection(true)
            .onAppear { self.focusedField = .mail }

            Button(String(l10n.ConnectionView.connectionButton.characters)) {
                self.submitForm()
            }
            .disabled(self.connectIsDisabled())
            .buttonStyle(.borderedProminent)
        }
        .navigationDestination(isPresented: self.$viewModel.navigateToTeacherSelector) {
            // TODO: (@release) - Implement selection + review nav destination use
            Text("ProfileSelectorCaregiverView")
        }
    }

    func connectIsDisabled() -> Bool {
        self.viewModel.email.isEmpty || self.viewModel.password.isEmpty
    }

    // MARK: Private

    @StateObject private var viewModel = ConnectionViewViewModel()

    @ViewBuilder
    private var mailTextField: some View {
        // TODO: (@dev/release) - Rework email validation w/ AccountKit
        LekaTextField(
            label: String(l10n.ConnectionView.TextField.email.characters),
            entry: self.$viewModel.email,
            color: .primary, // TODO: (@ui/ux) - Design System - review color
            isEditing: self.$viewModel.isEditing,
            focused: _focusedField
        ) {
            self.focusedField = .password
        }
    }

    @ViewBuilder
    private var passwordTextField: some View {
        // TODO: (@dev/release) - Rework email validation w/ AccountKit
        LekaPasswordField(
            label: String(l10n.ConnectionView.TextField.password.characters),
            entry: self.$viewModel.password,
            color: .primary, // TODO: (@ui/ux) - Design System - review color
            focused: _focusedField
        ) {
            if self.viewModel.password.isEmpty {
                self.focusedField = .password
            } else {
                self.submitForm()
            }
        }
    }

    private func submitForm() {
        // TODO: (@release) - Plug to AccountKit
        self.viewModel.navigateToTeacherSelector.toggle()
    }
}

#Preview {
    ConnectionView()
}
