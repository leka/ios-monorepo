// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - ColorPad

extension ColorPad {
    struct TwoHalvesBeltView: View {
        @Binding var padState: PadState

        var body: some View {
            HStack(spacing: 50) {
                EarButton(selectedEar: .earLeft(in: .purple), padState: self.$padState)
                EarButton(selectedEar: .earRight(in: .green), padState: self.$padState)
            }
            ZStack {
                BeltSectionButton(section: .halfLeft(in: .red), padState: self.$padState)
                BeltSectionButton(section: .halfRight(in: .blue), padState: self.$padState)
            }
        }
    }
}

#Preview {
    ColorPad.TwoHalvesBeltView(padState: .constant(.released))
}
