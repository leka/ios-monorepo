// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TwoHalvesIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 60, height: 60)

            beltSectionIcons

            HStack {
                EarIcon()
                EarIcon()
            }
        }
    }

    private var beltSectionIcons: some View {
        ZStack {
            BeltSectionIcon(startAngle: .degrees(10), endAngle: .degrees(170))
            BeltSectionIcon(startAngle: .degrees(190), endAngle: .degrees(350))
        }
    }
}

struct TwoHalvesIcon_Previews: PreviewProvider {
    static var previews: some View {
        TwoHalvesIcon()
    }
}
