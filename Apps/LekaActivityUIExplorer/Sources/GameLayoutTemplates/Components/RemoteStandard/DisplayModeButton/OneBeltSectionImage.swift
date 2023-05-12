// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct OneBeltSectionImage: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 60, height: 60)

            BeltSectionImage(startAngle: .degrees(0), endAngle: .degrees(360))

            EarImage()

        }
    }
}
struct OneBeltSectionImage_Previews: PreviewProvider {
    static var previews: some View {
        OneBeltSectionImage()
    }
}
