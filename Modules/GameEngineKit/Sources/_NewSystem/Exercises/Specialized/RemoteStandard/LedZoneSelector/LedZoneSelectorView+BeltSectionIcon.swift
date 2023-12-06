// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension LedZoneSelectorView {

    struct BeltSectionIcon: View {
        var section: Robot.Lights

        @State private var backgroundLineWidth = 0

        var body: some View {
            LedZoneShape(section: section)
                .stroke(.black, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 60, height: 60)
        }
    }
}

#Preview {
    LedZoneSelectorView.BeltSectionIcon(section: .full(.belt, in: .red))
}
