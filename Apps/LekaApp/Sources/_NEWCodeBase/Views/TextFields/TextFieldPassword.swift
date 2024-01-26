// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

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

                Button("", systemImage: self.isSecured ? "eye" : "eye.slash") {
                    self.isSecured.toggle()
                }
                .disabled(self.entry.isEmpty)
            }
        }
    }

    // MARK: Private

    @State private var isSecured: Bool = true
}

#Preview {
    TextFieldPassword(entry: .constant(""))
}
