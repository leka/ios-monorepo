// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - ColorPad

struct ColorPad: View {
    let displayMode: Gamepad.DisplayMode
    @Binding var padState: PadState

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 300, height: 300)

            VStack {
                Image(systemName: "chevron.up")
                    .foregroundColor(.gray.opacity(0.7))
                Text(l10n.ColorPad.frontLabel)
                    .foregroundColor(.gray.opacity(0.7))

                Spacer()
            }
            .padding(20)

            switch self.displayMode {
                case .fullBelt:
                    FullBeltView(padState: self.$padState)
                case .twoHalves:
                    TwoHalvesBeltView(padState: self.$padState)
                case .fourQuarters:
                    FourQuartersBeltView(padState: self.$padState)
            }
        }
    }
}

// MARK: - l10n.ColorPad

extension l10n {
    enum ColorPad {
        static let frontLabel = LocalizedString("game_engine_kit.led_zone_selector_view.front_label",
                                                bundle: ContentKitResources.bundle,
                                                value: "Front",
                                                comment: "Label that shows where the front is on the ColorPad")
    }
}

#Preview {
    ColorPad(displayMode: .twoHalves, padState: .constant(.fullyPressed))
}
