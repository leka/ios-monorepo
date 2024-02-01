// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension AvatarPicker {
    struct AvatarCellLabel: View {
        // MARK: Internal

        let image: String
        @Binding var isSelected: Bool

        var body: some View {
            Image(self.image, bundle: Bundle(for: DesignKitResources.self))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(maxWidth: 125, maxHeight: 125)
                .animation(.default, value: self.isSelected)
                .overlay(
                    Circle()
                        .stroke(self.styleManager.accentColor!,
                                lineWidth: self.isSelected ? 7 : 0)
                )
        }

        // MARK: Private

        @ObservedObject private var styleManager: StyleManager = .shared
    }
}

#Preview {
    HStack {
        AvatarPicker.AvatarCellLabel(image: DesignKitAsset.Avatars.accompanyingBlue.name, isSelected: .constant(false))
        AvatarPicker.AvatarCellLabel(image: DesignKitAsset.Avatars.accompanyingBlue.name, isSelected: .constant(true))
    }
}
