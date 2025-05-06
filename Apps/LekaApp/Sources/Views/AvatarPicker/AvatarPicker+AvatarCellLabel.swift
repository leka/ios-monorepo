// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import SwiftUI

extension AvatarPicker {
    struct AvatarCellLabel: View {
        // MARK: Internal

        var styleManager: StyleManager = .shared
        let image: UIImage
        @Binding var isSelected: Bool

        var body: some View {
            Image(uiImage: self.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(DesignKitAsset.Colors.blueGray.swiftUIColor)
                .clipShape(Circle())
                .frame(maxWidth: 130, maxHeight: 130)
                .animation(.default, value: self.isSelected)
                .overlay(
                    Circle()
                        .stroke(self.styleManager.accentColor!,
                                lineWidth: self.isSelected ? 4 : 0)
                )
        }
    }
}

#Preview {
    HStack {
        AvatarPicker.AvatarCellLabel(image: Avatars.iconToUIImage(icon: Avatars.categories[0].avatars[0]), isSelected: .constant(false))
        AvatarPicker.AvatarCellLabel(image: Avatars.iconToUIImage(icon: Avatars.categories[0].avatars[0]), isSelected: .constant(true))
    }
}
