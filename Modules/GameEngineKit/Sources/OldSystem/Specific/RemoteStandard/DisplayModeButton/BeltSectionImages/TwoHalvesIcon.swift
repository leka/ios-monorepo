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
            BeltSectionIcon(section: .right)
            BeltSectionIcon(section: .left)
        }
    }
}

struct TwoHalvesIcon_Previews: PreviewProvider {
    static var previews: some View {
        TwoHalvesIcon()
    }
}
