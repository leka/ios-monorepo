// Leka - iOS Monorepo
// Copyright APF France handicap
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
                self.title
                Group {
                    self.mailTextField
                    VStack(spacing: 0) {
                        self.passwordTextField
                        self.forgotLink
                    }
                }
                .frame(width: 400)
                .disableAutocorrection(true)
                .onAppear { self.focusedField = .mail }
                self.submitButton
            }
        }
        .navigationDestination(isPresented: self.$navigateToTeacherSelector) {
            ProfileSelector_Teachers()
        }
    }

    // Make sure you have set up Associated Domains for your app and AutoFill Passwords
    // is enabled in Settings in order to get the strong password proposals etc...
    // the same applies for both login/signup
    // re-enable autofill modifiers in LekaTextField when OK (textContentType)

    func connectIsDisabled() -> Bool {
        !self.mail.isValidEmail() || self.mail.isEmpty || self.password.isEmpty
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
            .font(self.metrics.semi20)
    }

    private var submitButton: some View {
        Button(
            action: {
                self.submitForm()
            },
            label: {
                Text("Connexion")
                    .font(self.metrics.bold15)
                    .padding(6)
                    .frame(width: 210)
            }
        )
        .disabled(self.connectIsDisabled())
        .buttonStyle(.borderedProminent)
        .tint(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        .padding(.top, 24)
    }

    @ViewBuilder
    private var mailTextField: some View {
        let mailTitle: String = {
            guard self.mail.isValidEmail() || self.mail.isEmpty || self.isEditing else {
                return "Email incorrect"
            }
            return "Email"
        }()

        let mailLabelColor: Color = self.mail.isValidEmail() || self.mail.isEmpty || self.isEditing
            ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : .red

        LekaTextField(
            label: mailTitle,
            entry: self.$mail,
            color: mailLabelColor,
            isEditing: self.$isEditing,
            focused: _focusedField
        ) {
            self.focusedField = .password
        }
    }

    @ViewBuilder
    private var passwordTextField: some View {
        let passwordTitle: String = {
            guard self.credentialsAreCorrect else {
                return "Email ou mot de passe incorrect"
            }
            return "Mot de passe"
        }()

        let passwordLabelColor: Color = self.credentialsAreCorrect ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : .red

        LekaPasswordField(
            label: passwordTitle,
            entry: self.$password,
            color: passwordLabelColor,
            focused: _focusedField
        ) {
            if self.password.isEmpty {
                self.focusedField = .password
            } else {
                self.submitForm()
            }
        }
    }

    private var forgotLink: some View {
        HStack {
            Spacer()
            Link(destination: URL(string: "https://leka.io")!) {
                Text("Mot de passe oublié")
                    .font(self.metrics.reg14)
                    .underline()
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                    .padding([.top, .trailing], 10)
            }
        }
    }

    private func submitForm() {
        if self.mail == LekaCompany().lekaCompany.mail {
            if self.password != LekaCompany().lekaCompany.password {
                self.credentialsAreCorrect = false
            } else {
                self.credentialsAreCorrect = true
                self.settings.companyIsConnected = true
                self.company.currentCompany = LekaCompany().lekaCompany
                self.settings.companyIsLoggingIn = true
                self.navigateToTeacherSelector.toggle()
            }
        } else {
            self.credentialsAreCorrect = false
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
