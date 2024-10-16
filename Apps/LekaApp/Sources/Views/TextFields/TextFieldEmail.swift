// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - l10n.TextFieldEmail

// swiftlint:disable line_length

extension l10n {
    enum TextFieldEmail {
        static let label = LocalizedString("lekaapp.TextFieldEmail.label", value: "Email", comment: "TextFieldEmail label")

        static let invalidEmailErrorLabel = LocalizedString("lekaapp.TextFieldEmail.invalidEmailErrorLabel", value: "The email is not valid", comment: "TextFieldEmail invalid Email Error Label")
    }
}

// MARK: - TextFieldEmail

// swiftlint:enable line_length

struct TextFieldEmail: View {
    // MARK: Internal

    @Binding var entry: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(l10n.TextFieldEmail.label)

            TextField("", text: self.$entry)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused(self.$focused)
                .onChange(of: self.focused) { focused in
                    if !focused {
                        self.entry = self.entry.trimLeadingAndTrailingWhitespaces()
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(self.focused ? .blue : .clear, lineWidth: 1)
                )

            Text(l10n.TextFieldEmail.invalidEmailErrorLabel)
                .font(.footnote)
                .foregroundStyle(self.isErrorMessageVisible ? .red : .clear)
        }
        .onAppear {
            self.focused = true
        }
    }

    // MARK: Private

    @FocusState private var focused: Bool

    private var isErrorMessageVisible: Bool {
        self.entry.isInvalidEmail(checkEmpty: false) && !self.entry.isEmpty && !self.focused
    }
}

#Preview {
    TextFieldEmail(entry: .constant("john.doe@mail.com"))
}
