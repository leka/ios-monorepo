// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - l10n.TextFieldPassword

// swiftlint:disable line_length

extension l10n {
    enum TextFieldPassword {
        static let label = LocalizedString("lekaapp.TextFieldPassword.label", value: "Password", comment: "TextFieldPassword label")

        static let invalidPasswordErrorLabel = LocalizedString("lekaapp.TextFieldPassword.invalidPasswordErrorLabel", value: "12 characters minimum, no spaces", comment: "TextFieldPassword invalid Password Error Label")
    }
}

// MARK: - TextFieldPassword

// swiftlint:enable line_length

struct TextFieldPassword: View {
    // MARK: Internal

    @Binding var entry: String

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
                .textContentType(.password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused(self.$focused)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(self.focused ? .blue : .clear, lineWidth: 1)
                )

                Button("", systemImage: self.isSecured ? "eye" : "eye.slash") {
                    self.isSecured.toggle()
                }
            }

            if self.authManagerViewModel.userAction == .userIsSigningUp {
                Text(l10n.TextFieldPassword.invalidPasswordErrorLabel)
                    .font(.footnote)
                    .lineLimit(2)
                    .foregroundStyle(self.entry.isValidPassword() ? .green : .gray)
            }
        }
    }

    // MARK: Private

    @FocusState private var focused: Bool

    @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared
    @State private var isSecured: Bool = true
}

#Preview {
    TextFieldPassword(entry: .constant(""))
}
