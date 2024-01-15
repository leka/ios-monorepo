// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - MailTextField

struct MailTextField: View {
    let label: String

    @Binding var entry: String

    @FocusState var focused: FormField?

    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(self.label)

            TextField("", text: self.$entry)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .focused(self.$focused, equals: .mail)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .onSubmit { self.action() }
        }
    }
}

#Preview {
    MailTextField(label: "Email", entry: .constant("")) {
        print("Email entered")
    }
}
