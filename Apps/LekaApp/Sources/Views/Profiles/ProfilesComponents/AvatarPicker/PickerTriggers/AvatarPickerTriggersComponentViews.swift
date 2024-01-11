// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - AvatarTriggerImageView

struct AvatarTriggerImageView: View {
    var img: String

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
            Group {
                Image(self.img, bundle: Bundle(for: DesignKitResources.self))
                    .resizable()
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .padding(10)
            }
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
            Circle()
                .inset(by: 10)
                .strokeBorder(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor, lineWidth: 4, antialiased: true)
        }
        .frame(width: 170, height: 170)
    }
}

// MARK: - AvatarTriggerCTAView

struct AvatarTriggerCTAView: View {
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Text("choisir un avatar")
            // TODO: (@ui/ux) - Design System - replace with Leka font
            .font(.body)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
            .padding(.vertical, 4)
            .padding(.horizontal, 20)
            .overlay(
                Capsule()
                    .stroke(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor, lineWidth: 1)
            )
            .background(.white, in: Capsule())
            .padding(10)
    }
}
