// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SignupView: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    @FocusState var focusedField: FormField?
    @State private var isEditing = false
    @State private var mail: String = ""
    @State private var password: String = ""
    @State private var confirm: String = ""
    @State private var accountAlreadyExists: Bool = false
    @State private var navigateToSignup1: Bool = false

    func connectIsDisabled() -> Bool {
        !mail.isValidEmail() || !passwordsMatch() || mail.isEmpty || password.isEmpty || confirm.isEmpty
            || accountAlreadyExists
    }

    func passwordsMatch() -> Bool {
        password == confirm
    }

    func checkAccountAvailability() {
        accountAlreadyExists = (mail == "test@leka.io")
    }

    private func submitForm() {
        checkAccountAvailability()
        if accountAlreadyExists {
            password = ""
            confirm = ""
        } else {
            company.currentCompany.mail = mail
            company.currentCompany.password = password
            settings.companyIsConnected = true
            navigateToSignup1.toggle()
        }
    }

    var body: some View {
        ZStack(alignment: .center) {
            CloudsBGView()

            VStack(alignment: .center, spacing: 30) {
                title
                Group {
                    mailTextField
                    passwordTextField
                    confirmTextField
                }
                .frame(width: 400)
                .disableAutocorrection(true)
                .onAppear { focusedField = .mail }
                submitButton
            }
        }
        .navigationDestination(isPresented: $navigateToSignup1) {
            SignupStep1()
        }
    }

    @ViewBuilder
    private var mailTextField: some View {
        let mailTitle: String = {
            guard mail.isValidEmail() || mail.isEmpty || isEditing else {
                return "Email incorrect"
            }
            guard accountAlreadyExists else {
                return "Email"
            }
            return "Ce compte existe déjà"
        }()

        let mailLabelColor: Color = {
            // TODO(@ladislas): review logic in the future
            var color: Color

            if mail.isValidEmail() || mail.isEmpty || isEditing {
                if accountAlreadyExists {
                    color = .red
                } else {
                    color = .accentColor
                }
            } else {
                color = .red
            }

            return color
        }()

        LekaTextField(
            label: mailTitle, entry: $mail, color: mailLabelColor, isEditing: $isEditing, focused: _focusedField
        ) {
            focusedField = .password
        }
        .onChange(of: mail) { _ in
            if accountAlreadyExists {
                checkAccountAvailability()
            }
        }
    }

    private var passwordTextField: some View {
        LekaPasswordField(label: "Mot de passe", entry: $password, focused: _focusedField) {
            if !password.isEmpty {
                focusedField = .confirm
            } else {
                focusedField = .password
            }
        }
    }

    @ViewBuilder
    private var confirmTextField: some View {
        let confirmTitle: String = {
            guard passwordsMatch() || password.isEmpty || confirm.isEmpty else {
                return "Les mots de passe ne sont pas identiques"
            }
            return "Confirmer le mot de passe"
        }()

        let confirmLabelColor: Color = {
            return passwordsMatch() || confirm.isEmpty ? .accentColor : .red
        }()

        LekaPasswordField(
            label: confirmTitle, entry: $confirm, color: confirmLabelColor, type: .confirm, focused: _focusedField
        ) {
            if confirm.isEmpty || !passwordsMatch() {
                focusedField = .confirm
            } else {
                submitForm()
            }
        }
    }

    private var title: some View {
        Text("Créer un compte")
            .textCase(.uppercase)
            .foregroundColor(.accentColor)
            .font(metrics.semi20)
    }

    private var submitButton: some View {
        Button(
            action: {
                submitForm()
            },
            label: {
                Text("Connexion")
                    .font(metrics.bold15)
                    .padding(6)
                    .frame(width: 210)
            }
        )
        .disabled(connectIsDisabled())
        .buttonStyle(.borderedProminent)
        .tint(.accentColor)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
            .environmentObject(CompanyViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
