// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

extension ColorPad {
    enum PadState: Equatable {
        case released
        case fullyPressed

        // MARK: Internal

        mutating func toggle() {
            if self == .released {
                self = .fullyPressed
            } else {
                self = .released
            }
        }
    }

    struct PadModeButton: View {
        // MARK: Internal

        var mode: Gamepad.DisplayMode
        @Binding var displayMode: Gamepad.DisplayMode
        @Binding var padState: PadState

        var body: some View {
            Button {
                if self.displayMode == self.mode {
                    self.padState.toggle()
                } else {
                    self.padState = .released
                    self.displayMode = self.mode
                    Robot.shared.blacken(.all)
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 60, height: 60)

                    self.beltSectionIcons
                    self.earsSectionIcons
                }
            }
            .background(
                Circle()
                    .foregroundColor(DesignKitAsset.Colors.btnLightBlue.swiftUIColor)
                    .frame(width: CGFloat(self.displayMode == self.mode ? 80 : 0),
                           height: CGFloat(self.displayMode == self.mode ? 80 : 0))
            )
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
    ColorPad.PadModeButton(mode: .fullBelt, displayMode: .constant(.fullBelt), padState: .constant(.fullyPressed))
}
