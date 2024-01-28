// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - l10n.TextFieldPassword

extension l10n {
    enum TextFieldPassword {
        static let label = LocalizedString("lekaapp.TextFieldPassword.label", value: "Password", comment: "TextFieldPassword label")
    }
}

// MARK: - TextFieldPassword

struct TextFieldPassword: View {
    // MARK: Internal

    @Binding var entry: String
    @FocusState var focused: Focusable?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(l10n.TextFieldPassword.label)

            HStack {
                Group {
                    if self.isSecured {
                        SecureField("", text: self.$entry)
                    } else {
                        TextField("", text: self.$entry)
                    }
                }
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .textContentType(.password)
                .onReceive(Just(self.entry)) { newValue in
                    if self.focused != .password {
                        self.entry = newValue.trimmingCharacters(in: .whitespaces)
                    }
                }
                .focused(self.$focused, equals: .password)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(self.focused == .password ? .blue : .clear, lineWidth: 1)
                )

                Button("", systemImage: self.isSecured ? "eye" : "eye.slash") {
                    self.isSecured.toggle()
                }
                .disabled(self.entry.isEmpty)
            }

            Text("8 characters minimum, including at least one number and one Capital letter.")
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.footnote)
                .foregroundStyle(self.errorMessageCanShow ? .red : .clear)
        }
    }

    // MARK: Private

    @State private var isSecured: Bool = true

    private var errorMessageCanShow: Bool {
        !self.entry.isValidPassword() && !self.entry.isEmpty && self.focused != .password
    }
}

#Preview {
    TextFieldPassword(entry: .constant(""))
}
