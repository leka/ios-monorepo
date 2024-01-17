// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - SignupViewDeprecated

struct SignupViewDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    @FocusState var focusedField: FormField?

    var body: some View {
        ZStack(alignment: .center) {
            CloudsBGView()

            VStack(alignment: .center, spacing: 30) {
                self.title
                Group {
                    self.mailTextField
                    self.passwordTextField
                    self.confirmTextField
                }
                .frame(width: 400)
                .disableAutocorrection(true)
                .onAppear { self.focusedField = .mail }
                self.submitButton
            }
        }
        .navigationDestination(isPresented: self.$navigateToSignup1) {
            SignupStep1Deprecated()
        }
    }

    func connectIsDisabled() -> Bool {
        !self.mail.isValidEmail() || !self.passwordsMatch() || self.mail.isEmpty || self.password.isEmpty || self.confirm.isEmpty
            || self.accountAlreadyExists
    }

    func passwordsMatch() -> Bool {
        self.password == self.confirm
    }

    func checkAccountAvailability() {
        self.accountAlreadyExists = (self.mail == "test@leka.io")
    }

    // MARK: Private

    @State private var isEditing = false
    @State private var mail: String = ""
    @State private var password: String = ""
    @State private var confirm: String = ""
    @State private var accountAlreadyExists: Bool = false
    @State private var navigateToSignup1: Bool = false

    @ViewBuilder
    private var mailTextField: some View {
        var mailTitle: String {
            guard self.mail.isValidEmail() || self.mail.isEmpty || self.isEditing else {
                return "Email incorrect"
            }
            guard self.accountAlreadyExists else {
                return "Email"
            }
            return "Ce compte existe déjà"
        }

        var mailLabelColor: Color {
            // TODO(@ladislas): review logic in the future
            let color: Color = if self.mail.isValidEmail() || self.mail.isEmpty || self.isEditing {
                if self.accountAlreadyExists {
                    .red
                } else {
                    DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
                }
            } else {
                .red
            }

            return color
        }

        LekaTextFieldDeprecated(
            label: mailTitle,
            entry: self.$mail,
            color: mailLabelColor,
            isEditing: self.$isEditing,
            focused: _focusedField
        ) {
            self.focusedField = .password
        }
        .onChange(of: self.mail) { _ in
            if self.accountAlreadyExists {
                self.checkAccountAvailability()
            }
        }
    }

    private var passwordTextField: some View {
        LekaPasswordFieldDeprecated(
            label: "Mot de passe",
            entry: self.$password,
            focused: _focusedField
        ) {
            if !self.password.isEmpty {
                self.focusedField = .confirm
            } else {
                self.focusedField = .password
            }
        }
    }

    @ViewBuilder
    private var confirmTextField: some View {
        let confirmTitle: String = {
            guard self.passwordsMatch() || self.password.isEmpty || self.confirm.isEmpty else {
                return "Les mots de passe ne sont pas identiques"
            }
            return "Confirmer le mot de passe"
        }()

        let confirmLabelColor: Color = self.passwordsMatch() || self.confirm.isEmpty ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : .red

        LekaPasswordFieldDeprecated(
            label: confirmTitle,
            entry: self.$confirm,
            color: confirmLabelColor,
            type: .confirm,
            focused: _focusedField
        ) {
            if self.confirm.isEmpty || !self.passwordsMatch() {
                self.focusedField = .confirm
            } else {
                self.submitForm()
            }
        }
    }

    private var title: some View {
        Text("Créer un compte")
            // TODO: (@ui/ux) - Design System - replace with Leka font
            .font(.title)
    }

    private var submitButton: some View {
        Button(
            action: {
                self.submitForm()
            },
            label: {
                Text("Connexion")
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.body)
                    .padding(6)
                    .frame(width: 210)
            }
        )
        .disabled(self.connectIsDisabled())
        .buttonStyle(.borderedProminent)
    }

    private func submitForm() {
        self.checkAccountAvailability()
        if self.accountAlreadyExists {
            self.password = ""
            self.confirm = ""
        } else {
            self.company.currentCompany.mail = self.mail
            self.company.currentCompany.password = self.password
            self.settings.companyIsConnected = true
            self.navigateToSignup1.toggle()
        }
    }
}

// MARK: - SignupViewDeprecated_Previews

struct SignupViewDeprecated_Previews: PreviewProvider {
    static var previews: some View {
        SignupViewDeprecated()
            .environmentObject(CompanyViewModelDeprecated())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
