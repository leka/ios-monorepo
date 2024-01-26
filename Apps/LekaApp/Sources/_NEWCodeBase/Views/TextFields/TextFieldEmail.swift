// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

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
    @Binding var entry: String

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
                    self.entry = newValue.trimmingCharacters(in: .whitespaces)
                }
        }
    }
}

#Preview {
    TextFieldEmail(entry: .constant("john.doe@mail.com"))
}
