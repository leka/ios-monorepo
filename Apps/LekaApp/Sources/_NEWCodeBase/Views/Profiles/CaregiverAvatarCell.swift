// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import SwiftUI

struct CaregiverAvatarCell: View {
    let caregiver: Caregiver

    var body: some View {
        VStack(spacing: 10) {
            Image(uiImage: Avatars.iconToUIImage(icon: self.caregiver.avatar))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(DesignKitAsset.Colors.blueGray.swiftUIColor)
                .clipShape(Circle())

            Text("\(self.caregiver.firstName) \(self.caregiver.lastName)")
                .font(.headline)
        }
    }
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
