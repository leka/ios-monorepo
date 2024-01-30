// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// Check if email or password format is correct
public extension String {
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self) && !self.isEmpty
    }

    func isInvalidEmail(checkEmpty: Bool = true) -> Bool {
        guard checkEmpty else {
            return !self.isValidEmail()
        }
        return !self.isValidEmail() || self.isEmpty
    }

    func isValidPassword() -> Bool {
        // 8 characters minimum, must contain at least one number and one Capital letter
        let regex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self) && !self.isEmpty
    }

    func isInvalidPassword() -> Bool {
        !self.isValidPassword() || self.isEmpty
    }
}