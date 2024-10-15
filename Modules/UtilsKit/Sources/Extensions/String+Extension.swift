// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension String {
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }

    var isRasterImageFile: Bool {
        ["png", "jpg", "jpeg"].contains(self.pathExtension)
    }

    var isVectorImageFile: Bool {
        self.pathExtension == "svg"
    }

    var fileURL: URL {
        URL(fileURLWithPath: self)
    }

    var pathExtension: String {
        self.fileURL.pathExtension
    }

    var lastPathComponent: String {
        self.fileURL.lastPathComponent
    }

    var filenameWithoutExtension: String {
        (self.lastPathComponent as NSString).deletingPathExtension
    }

    func containsEmoji() -> Bool {
        contains { $0.isEmoji }
    }

    func containsOnlyEmojis() -> Bool {
        count > 0 && !contains { !$0.isEmoji }
    }

    var nilWhenEmpty: String? {
        isEmpty ? nil : self
    }

    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self) && !self.isEmpty
    }

    func trimLeadingAndTrailingWhitespaces() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func containsInvalidCharacters() -> Bool {
        self.contains { $0.isWhitespace }
    }

    func isInvalidEmail(checkEmpty: Bool = true) -> Bool {
        guard checkEmpty else {
            return !self.isValidEmail()
        }
        return !self.isValidEmail() || self.isEmpty
    }

    func isValidPassword() -> Bool {
        // 8 characters minimum, must contain at least one number and one Capital letter
        let regex = "^[^\\s]{12,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self) && !self.isEmpty
    }

    func isInvalidPassword() -> Bool {
        !self.isValidPassword() || self.isEmpty
    }

    func normalized() -> String {
        self.folding(options: .diacriticInsensitive, locale: .current).lowercased()
    }
}
