// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct TwoHalvesSelector: View {
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
                EarButton(selectedEar: .left, color: DesignKitAsset.Colors.lekaActivityOrange.swiftUIColor)
                EarButton(selectedEar: .right, color: DesignKitAsset.Colors.lekaActivityBlue.swiftUIColor)
            }
        }
    }

    private var beltSectionButtons: some View {
        ZStack {
            BeltSectionButton(section: .right, color: DesignKitAsset.Colors.lekaActivityRed.swiftUIColor)
            BeltSectionButton(section: .left, color: DesignKitAsset.Colors.lekaActivityBlue.swiftUIColor)
        }
    }
}

struct TwoHalvesSelector_Previews: PreviewProvider {
    static var previews: some View {
        TwoHalvesSelector()
    }
}
