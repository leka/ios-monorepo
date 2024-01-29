// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// Avatar Buttons within the AvatarPicker()
struct AvatarButtonLabelDeprecated: View {
    @EnvironmentObject var metrics: UIMetrics

    @Binding var image: String
    @Binding var isSelected: Bool

    var body: some View {
        ZStack {
            Image(self.image, bundle: Bundle(for: DesignKitResources.self))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: self.metrics.diameter, maxHeight: self.metrics.diameter)
                .background(.white)
                .mask(Circle())
            Circle()
                .strokeBorder(DesignKitAsset.Colors.lekaLightGray.swiftUIColor, lineWidth: 2)
        }
        .frame(minWidth: self.metrics.diameter, maxWidth: self.metrics.diameter)
        .background(
            DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor,
            in: Circle().inset(by: self.isSelected ? -7 : 2)
        )
        .animation(.default, value: self.isSelected)
    }
}
