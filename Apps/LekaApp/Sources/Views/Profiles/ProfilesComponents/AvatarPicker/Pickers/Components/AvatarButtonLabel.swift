// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// Avatar Buttons within the AvatarPicker()
struct AvatarButtonLabel: View {
    @EnvironmentObject var metrics: UIMetrics

    @Binding var image: String
    @Binding var isSelected: Bool

    var body: some View {
        ZStack {
            Image(image, bundle: Bundle(for: DesignKitResources.self))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: metrics.diameter, maxHeight: metrics.diameter)
                .background(.white)
                .mask(Circle())
            Circle()
                .strokeBorder(DesignKitAsset.Colors.lekaLightGray.swiftUIColor, lineWidth: 2)
        }
        .frame(minWidth: metrics.diameter, maxWidth: metrics.diameter)
        .background(
            DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor,
            in: Circle().inset(by: isSelected ? -7 : 2)
        )
        .animation(.default, value: isSelected)
    }
}
