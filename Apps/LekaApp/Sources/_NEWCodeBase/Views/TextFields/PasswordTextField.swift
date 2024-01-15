// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - PasswordTextField

struct PasswordTextField: View {
    let label: String
    var type: FormField

    @Binding var entry: String
    @State private var isSecured: Bool = true
    @FocusState var focused: FormField?

    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(self.label)

            HStack(spacing: 30) {
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
                .focused(self.$focused, equals: self.type)
                .onSubmit { self.action() }

                Button {
                    self.isSecured.toggle()
                } label: {
                    Image(systemName: self.isSecured ? "eye" : "eye.slash")
                        .padding()
                }
                .disabled(self.entry.isEmpty)
            }
        }
    }
}

#Preview {
    PasswordTextField(label: "Password", type: .password, entry: .constant("")) {
        print("Password entered")
    }
}
