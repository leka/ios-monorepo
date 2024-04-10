// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

extension RemoteStandard {
    struct ArrowCommand: View {
        // MARK: Internal

        var body: some View {
            HStack(spacing: 150) {
                VStack(spacing: 200) {
                    Spacer()

                    RemoteArrowView(size: 130, xPosition: 130)
                }

                RadialLayout(firstButtonPosX: -120, firstButtonPosY: -200, angle: 90.0) {
                    LedZoneSelectorView(displayMode: self.displayMode)

                    ForEach(DisplayMode.allCases, id: \.self) { mode in
                        LedZoneSelectorView.ModeButton(mode: mode, displayMode: self.$displayMode)
                    }
                }
            }
        }

        // MARK: Private

        @State private var displayMode = DisplayMode.fullBelt
    }
}

#Preview {
    RemoteStandard.ArrowCommand()
}
