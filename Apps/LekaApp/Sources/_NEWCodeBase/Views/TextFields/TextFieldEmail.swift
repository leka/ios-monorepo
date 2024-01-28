// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import DesignKit
import LocalizationKit
import SwiftUI

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
                    if self.focused != .email {
                        self.entry = newValue.trimmingCharacters(in: .whitespaces)
                    }
                }
                .onAppear { self.focused = .email }
                .focused(self.$focused, equals: .email)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(self.focused == .email ? .blue : .clear, lineWidth: 1)
                )

            Text(l10n.TextFieldEmail.invalidEmailErrorLabel)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.footnote)
                .foregroundStyle(self.errorMessageCanShow ? .red : .clear)
        }
    }

    // MARK: Private

    private var errorMessageCanShow: Bool {
        !self.entry.isValidEmail() && !self.entry.isEmpty && self.focused != .email
    }
}

#Preview {
    TextFieldEmail(entry: .constant("john.doe@mail.com"))
}
