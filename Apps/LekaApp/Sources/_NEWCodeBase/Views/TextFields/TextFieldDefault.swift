// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - TextFieldDefault

struct TextFieldDefault: View {
    let label: String
    @Binding var entry: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(self.label)

            TextField("", text: self.$entry)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
        }
    }
}

#Preview {
    TextFieldDefault(label: "Name", entry: .constant("Gaëtan"))
}
