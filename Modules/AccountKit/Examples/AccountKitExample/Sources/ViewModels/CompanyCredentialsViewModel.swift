// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct CompanyCredentialsViewModel {
    // var id = UUID().uuidString
    var mail: String = ""
    var password: String = ""
    // var teachers: [Teacher] = []
    // var users: [User] = []
    var confirmPassword: String = ""

    // MARK: - Validation Checks

    func isEmailValid() -> Bool {
        let mailTest = NSPredicate(format: "SELF MATCHES %@",
                                   "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return mailTest.evaluate(with: mail)
    }

    func isPasswordValid(_ password: String) -> Bool {
        // 8 chars min, contain a cap letter and a number at least
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$")
        return passwordTest.evaluate(with: password)
    }

    func passwordsMatch() -> Bool {
        confirmPassword == password
    }

    var signUpIsComplete: Bool  {
        if  !isEmailValid() ||
                !isPasswordValid(password) ||
                !passwordsMatch() {
            return false
        }
        return true
    }

    var logInIsComplete: Bool {
        if !isEmailValid() || !isPasswordValid(password) {
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
}
