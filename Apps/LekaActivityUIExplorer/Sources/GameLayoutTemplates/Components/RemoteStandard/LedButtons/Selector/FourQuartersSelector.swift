// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FourQuartersSelector: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 300, height: 300)

            VStack {
                Image(systemName: "chevron.up")
                    .foregroundColor(.gray.opacity(0.7))
                Text("Front")
                    .foregroundColor(.gray.opacity(0.7))

                Spacer()
            }
            .padding(20)

            BeltSectionView(startAngle: .degrees(10), endAngle: .degrees(80), color: .green)

            BeltSectionView(startAngle: .degrees(100), endAngle: .degrees(170), color: .blue)

            BeltSectionView(startAngle: .degrees(190), endAngle: .degrees(260), color: .red)

            BeltSectionView(startAngle: .degrees(280), endAngle: .degrees(350), color: .yellow)

            HStack(spacing: 50) {
                EarButton(color: .orange)

                EarButton(color: .blue)
            }
        }
    }
}

struct FourQuartersSelector_Previews: PreviewProvider {
    static var previews: some View {
        FourQuartersSelector()
    }
}
