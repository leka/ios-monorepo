// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - ColorPad

extension ColorPad {
    struct FourQuartersBeltView: View {
        @Binding var padState: PadState

        var body: some View {
            HStack(spacing: 50) {
                EarButton(selectedEar: .earLeft(in: .orange), padState: self.$padState)
                EarButton(selectedEar: .earRight(in: .blue), padState: self.$padState)
            }
            ZStack {
                BeltSectionButton(section: .quarterFrontRight(in: .green), padState: self.$padState)
                BeltSectionButton(section: .quarterBackRight(in: .blue), padState: self.$padState)
                BeltSectionButton(section: .quarterBackLeft(in: .red), padState: self.$padState)
                BeltSectionButton(section: .quarterFrontLeft(in: .yellow), padState: self.$padState)
            }
        }
    }
}

#Preview {
    ColorPad.FourQuartersBeltView(padState: .constant(.released))
}
