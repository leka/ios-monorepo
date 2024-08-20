// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import SwiftUI

extension AvatarPicker {
    struct ButtonLabel: View {
        // MARK: Internal

        let image: String

        var body: some View {
            // [] TODO: (@team) - Replace with proposal below
            // if self.image.isEmpty {
            if self.image == "" {
                Image(systemName: "photo.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .foregroundStyle(self.styleManager.accentColor!)
            } else {
                Image(uiImage: Avatars.iconToUIImage(icon: self.image))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(DesignKitAsset.Colors.blueGray.swiftUIColor)
                    .clipShape(Circle())
                    .frame(width: 125, height: 125)
                    .overlay(
                        Circle()
                            .stroke(self.styleManager.accentColor!, lineWidth: 2)
                    )
            }
        }

        // MARK: Private

        @ObservedObject private var styleManager: StyleManager = .shared
    }
}

#Preview {
    HStack {
        AvatarPicker.ButtonLabel(image: "")

        AvatarPicker.ButtonLabel(image: Avatars.categories[0].avatars[0])
    }
}
