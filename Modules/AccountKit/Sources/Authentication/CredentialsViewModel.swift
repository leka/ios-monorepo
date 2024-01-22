// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct CredentialsViewModel {
    public static var shared: CredentialsViewModel = .init()

    public var mail: String = ""
    public var password: String = ""
    public var confirmPassword: String = ""

    public var signUpIsComplete: Bool {
        if !self.isEmailValid() ||
            !self.isPasswordValid(self.password) ||
            !self.passwordsMatch()
        {
            return false
        }
        return true
    }

    public var logInIsComplete: Bool {
        if !self.isEmailValid() || !self.isPasswordValid(self.password) {
            return false
        }
        return true
    }

    // MARK: - Error Strings

    public var invalidEmailAddressText: String {
        "Enter a valid email address"
    }

    public var invalidPasswordText: String {
        "8 characters minimum. Must contain at least one number and one Capital letter."
    }

    public var invalidConfirmPasswordText: String {
        "Password fields do not match."
    }

    // MARK: - Validation Checks

    public func isEmailValid() -> Bool {
        let mailTest = NSPredicate(format: "SELF MATCHES %@",
                                   "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return mailTest.evaluate(with: self.mail)
    }

    public func isPasswordValid(_ password: String) -> Bool {
        // 8 chars min, contain a cap letter and a number at least
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$")
        return passwordTest.evaluate(with: password)
    }

    public func passwordsMatch() -> Bool {
        self.confirmPassword == self.password
    }
}
