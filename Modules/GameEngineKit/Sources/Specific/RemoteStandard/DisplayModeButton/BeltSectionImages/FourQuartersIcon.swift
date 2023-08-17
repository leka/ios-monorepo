// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FourQuartersIcon: View {
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
            BeltSectionIcon(section: .frontRight)
            BeltSectionIcon(section: .rearRight)
            BeltSectionIcon(section: .rearLeft)
            BeltSectionIcon(section: .frontLeft)
        }
    }
}

struct FourQuartersIcon_Previews: PreviewProvider {
    static var previews: some View {
        FourQuartersIcon()
    }
}
