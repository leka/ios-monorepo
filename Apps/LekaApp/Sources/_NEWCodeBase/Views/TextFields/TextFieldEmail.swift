// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - l10n.TextFieldEmail

extension l10n {
    enum TextFieldEmail {
        static let label = LocalizedString("lekaapp.TextFieldEmail.label", value: "Email", comment: "TextFieldEmail label")
    }
}

// MARK: - TextFieldEmail

struct TextFieldEmail: View {
    // MARK: Internal

    @Binding var entry: String
    @FocusState var focused: Focusable?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(l10n.TextFieldEmail.label)

            TextField("", text: self.$entry)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .onReceive(Just(self.entry)) { newValue in
                    if self.focused != .mail {
                        self.entry = newValue.trimmingCharacters(in: .whitespaces)
                    }
                }
                .onAppear { self.focused = .mail }
                .focused(self.$focused, equals: .mail)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(self.focused == .mail ? .blue : .clear, lineWidth: 1)
                )

            // TODO: (@team) - l10n that
            Text("Enter a valid email address")
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.footnote)
                .foregroundStyle(self.errorMessageCanShow ? .red : .clear)
        }
    }

    // MARK: Private

    private var errorMessageCanShow: Bool {
        !self.entry.isValidEmail() && !self.entry.isEmpty && self.focused != .mail
    }
}

#Preview {
    TextFieldEmail(entry: .constant("john.doe@mail.com"))
}
