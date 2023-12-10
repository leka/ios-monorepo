// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct OrganisationViewModel {
    var id = UUID().uuidString
    var mail: String = ""
    var password: String = ""
    // var teachers: [Teacher] = []
    // var users: [User] = []
    var confirmPassword: String = ""

    var signUpIsComplete: Bool {
        if !self.isEmailValid() || !self.isPasswordValid(self.password) || !self.passwordsMatch() {
            return false
        }
        return true
    }

    var logInIsComplete: Bool {
        if !self.isEmailValid() || !self.isPasswordValid(self.password) {
            return false
        }
        return true
    }

    // MARK: - Error Strings

    var invalidEmailAddressText: String {
        "Enter a valid email address"
    }

    var invalidPasswordText: String {
        "8 characters minimum. Must contain at least one number and one Capital letter."
    }

    var invalidConfirmPasswordText: String {
        "Password fields do not match."
    }

    // MARK: - Validation Checks

    func isEmailValid() -> Bool {
        let mailTest = NSPredicate(
            format: "SELF MATCHES %@",
            "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        )
        return mailTest.evaluate(with: self.mail)
    }

    func isPasswordValid(_ password: String) -> Bool {
        // 8 chars min, contain a cap letter and a number at least
        let passwordTest = NSPredicate(
            format: "SELF MATCHES %@",
            "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
        )
        return passwordTest.evaluate(with: password)
    }

    func passwordsMatch() -> Bool {
        self.confirmPassword == self.password
    }
}
