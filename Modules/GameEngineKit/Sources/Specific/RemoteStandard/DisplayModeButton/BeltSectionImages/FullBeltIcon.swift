// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FullBeltIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 60, height: 60)

            BeltSectionIcon(startAngle: .degrees(0), endAngle: .degrees(360))
            EarIcon()
        }
    }
}
struct FullBeltIcon_Previews: PreviewProvider {
    static var previews: some View {
        FullBeltIcon()
    }
}
