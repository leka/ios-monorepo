// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension LedZoneSelectorView {
    struct ModeButton: View {
        // MARK: Internal

        var mode: Gamepad.DisplayMode
        @Binding var displayMode: Gamepad.DisplayMode

        var body: some View {
            Button {
                self.displayMode = self.mode
                Robot.shared.blacken(.all)
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 60, height: 60)

                    self.beltSectionIcons
                    self.earsSectionIcons
                }
            }
            .background(ModeFeedback(backgroundDimension: self.displayMode == self.mode ? 80 : 0))
        }

        // MARK: Private

        private var earsSectionIcons: some View {
            HStack {
                switch self.mode {
                    case .fullBelt:
                        EarIcon()
                    case .twoHalves,
                         .fourQuarters:
                        EarIcon()
                        EarIcon()
                }
            }
        }

        private var beltSectionIcons: some View {
            ZStack {
                switch self.mode {
                    case .fullBelt:
                        BeltSectionIcon(section: .full(.belt, in: .black))
                    case .twoHalves:
                        BeltSectionIcon(section: .halfLeft(in: .black))
                        BeltSectionIcon(section: .halfRight(in: .black))
                    case .fourQuarters:
                        BeltSectionIcon(section: .quarterFrontRight(in: .black))
                        BeltSectionIcon(section: .quarterBackRight(in: .black))
                        BeltSectionIcon(section: .quarterBackLeft(in: .black))
                        BeltSectionIcon(section: .quarterFrontLeft(in: .black))
                }
            }
        }
    }
}

#Preview {
    LedZoneSelectorView.ModeButton(mode: .fullBelt, displayMode: .constant(.fullBelt))
}
