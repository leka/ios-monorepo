// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FourBeltSectionImage: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 60, height: 60)

            BeltSectionImage(startAngle: .degrees(10), endAngle: .degrees(80))

            BeltSectionImage(startAngle: .degrees(100), endAngle: .degrees(170))

            BeltSectionImage(startAngle: .degrees(190), endAngle: .degrees(260))

            BeltSectionImage(startAngle: .degrees(280), endAngle: .degrees(350))

            HStack {
                EarImage()

                EarImage()
            }
        }
    }
}

struct FourBeltSectionImage_Previews: PreviewProvider {
    static var previews: some View {
        FourBeltSectionImage()
    }
}
