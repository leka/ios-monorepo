// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import SwiftUI

struct CaregiverAvatarCell: View {
    // MARK: Lifecycle

    init(caregiver: Caregiver, isSelected: Bool = false) {
        self.caregiver = caregiver
        self.isSelected = isSelected
    }

    // MARK: Internal

    let caregiver: Caregiver
    var isSelected: Bool

    var body: some View {
        VStack(spacing: 10) {
            Image(uiImage: Avatars.iconToUIImage(icon: self.caregiver.avatar))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(DesignKitAsset.Colors.blueGray.swiftUIColor)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(self.styleManager.accentColor!, lineWidth: self.isSelected ? 5 : 0)
                }
                .frame(maxWidth: 120)

            Text("\(self.caregiver.firstName) \(self.caregiver.lastName)")
                .font(.headline)
                .lineLimit(2, reservesSpace: true)
        }
    }

    // MARK: Private

    private var styleManager: StyleManager = .shared
}

#Preview {
    CaregiverAvatarCell(
        caregiver: Caregiver(
            firstName: "Chantal",
            lastName: "Goya",
            avatar: Avatars.categories[2].avatars[4],
            professions: [],
            colorScheme: .dark,
            colorTheme: .orange
        )
    )
}
