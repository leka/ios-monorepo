// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - TextFieldDefault

struct TextFieldDefault: View {
    // MARK: Internal

    let label: String
    @Binding var entry: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(self.label)

            TextField("", text: self.$entry)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .focused(self.$focused)
                .onChange(of: self.focused) { focused in
                    if !focused {
                        self.entry = self.entry.trimLeadingAndTrailingWhitespaces()
                    }
                }
        }
    }

    // MARK: Private

    @FocusState private var focused: Bool
}

#Preview {
    TextFieldDefault(label: "Name", entry: .constant("Gaëtan"))
}
