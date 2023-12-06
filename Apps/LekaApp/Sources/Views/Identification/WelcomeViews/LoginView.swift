// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - LoginView

struct LoginView: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    @FocusState var focusedField: FormField?

    // TESTS *****************************************************************

    var body: some View {
        ZStack(alignment: .center) {
            CloudsBGView()

            VStack(alignment: .center, spacing: 30) {
                title
                Group {
                    mailTextField
                    VStack(spacing: 0) {
                        passwordTextField
                        forgotLink
                    }
                }
                .frame(width: 400)
                .disableAutocorrection(true)
                .onAppear { focusedField = .mail }
                submitButton
            }
        }
        .navigationDestination(isPresented: $navigateToTeacherSelector) {
            ProfileSelector_Teachers()
        }
    }

    // Make sure you have set up Associated Domains for your app and AutoFill Passwords
    // is enabled in Settings in order to get the strong password proposals etc...
    // the same applies for both login/signup
    // re-enable autofill modifiers in LekaTextField when OK (textContentType)

    func connectIsDisabled() -> Bool {
        !mail.isValidEmail() || mail.isEmpty || password.isEmpty
    }

    // MARK: Private

    @State private var mail: String = ""
    @State private var password: String = ""
    @State private var isEditing = false

    @State private var navigateToTeacherSelector: Bool = false

    // TESTS *****************************************************************
    @State private var credentialsAreCorrect: Bool = true

    private var title: some View {
        Text("Se connecter")
            .textCase(.uppercase)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
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
        .tint(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        .padding(.top, 24)
    }

    @ViewBuilder
    private var mailTextField: some View {
        let mailTitle: String = {
            guard mail.isValidEmail() || mail.isEmpty || isEditing else {
                return "Email incorrect"
            }
            return "Email"
        }()

        let mailLabelColor: Color = mail.isValidEmail() || mail.isEmpty || isEditing
            ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : .red

        LekaTextField(
            label: mailTitle,
            entry: $mail,
            color: mailLabelColor,
            isEditing: $isEditing,
            focused: _focusedField
        ) {
            focusedField = .password
        }
    }

    @ViewBuilder
    private var passwordTextField: some View {
        let passwordTitle: String = {
            guard credentialsAreCorrect else {
                return "Email ou mot de passe incorrect"
            }
            return "Mot de passe"
        }()

        let passwordLabelColor: Color = credentialsAreCorrect ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : .red

        LekaPasswordField(
            label: passwordTitle,
            entry: $password,
            color: passwordLabelColor,
            focused: _focusedField
        ) {
            if password.isEmpty {
                focusedField = .password
            } else {
                submitForm()
            }
        }
    }

    private var forgotLink: some View {
        HStack {
            Spacer()
            Link(destination: URL(string: "https://leka.io")!) {
                Text("Mot de passe oublié")
                    .font(metrics.reg14)
                    .underline()
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                    .padding([.top, .trailing], 10)
            }
        }
    }

    private func submitForm() {
        if mail == LekaCompany().lekaCompany.mail {
            if password != LekaCompany().lekaCompany.password {
                credentialsAreCorrect = false
            } else {
                credentialsAreCorrect = true
                settings.companyIsConnected = true
                company.currentCompany = LekaCompany().lekaCompany
                settings.companyIsLoggingIn = true
                navigateToTeacherSelector.toggle()
            }
        } else {
            credentialsAreCorrect = false
        }
    }
}

// MARK: - LoginView_Previews

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(CompanyViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
