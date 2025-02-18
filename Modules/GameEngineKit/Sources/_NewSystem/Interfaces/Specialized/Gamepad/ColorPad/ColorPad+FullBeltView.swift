// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - ColorPad

extension ColorPad {
    struct FullBeltView: View {
        @Binding var padState: PadState

        var body: some View {
            EarButton(selectedEar: .full(.ears, in: .blue), padState: self.$padState)
            BeltSectionButton(section: .full(.belt, in: .red), padState: self.$padState)
        }
    }
}

#Preview {
    ColorPad.FullBeltView(padState: .constant(.released))
}
