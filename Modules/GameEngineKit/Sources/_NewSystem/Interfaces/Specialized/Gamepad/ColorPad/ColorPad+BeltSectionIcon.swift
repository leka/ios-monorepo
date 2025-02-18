// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension ColorPad {
    struct BeltSectionIcon: View {
        // MARK: Internal

        var section: Robot.Lights

        var body: some View {
            LedZoneShape(section: self.section)
                .stroke(.black, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 60, height: 60)
        }

        // MARK: Private

        @State private var backgroundLineWidth = 0
    }
}

#Preview {
    ColorPad.BeltSectionIcon(section: .full(.belt, in: .red))
}
