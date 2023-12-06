// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension LedZoneSelectorView {

    struct ModeButton: View {
        var mode: RemoteStandard.DisplayMode
        @Binding var displayMode: RemoteStandard.DisplayMode

        var body: some View {
            Button {
                displayMode = mode
                Robot.shared.blacken(.all)
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 60, height: 60)

                    beltSectionIcons
                    earsSectionIcons
                }
            }
            .background(ModeFeedback(backgroundDimension: displayMode == mode ? 80 : 0))
        }

        private var earsSectionIcons: some View {
            HStack {
                switch mode {
                    case .fullBelt:
                        EarIcon()
                    case .twoHalves, .fourQuarters:
                        EarIcon()
                        EarIcon()
                }
            }
        }

        private var beltSectionIcons: some View {
            ZStack {
                switch mode {
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
