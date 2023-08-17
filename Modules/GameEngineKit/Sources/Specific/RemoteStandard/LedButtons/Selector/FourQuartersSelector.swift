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

            beltSectionButtons

            HStack(spacing: 50) {
                EarButton(color: .orange)
                EarButton(color: .blue)
            }
        }
    }

    private var beltSectionButtons: some View {
        ZStack {
            BeltSectionButton(section: .frontRight, color: .green)
            BeltSectionButton(section: .rearRight, color: .blue)
            BeltSectionButton(section: .rearLeft, color: .red)
            BeltSectionButton(section: .frontLeft, color: .yellow)
        }
    }
}

struct FourQuartersSelector_Previews: PreviewProvider {
    static var previews: some View {
        FourQuartersSelector()
    }
}
