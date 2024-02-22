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

            Text(self.caregiver.name)
                .font(.headline)
        }
    }
}

#Preview {
    CaregiverAvatarCell(caregiver: Caregiver(name: "Chantal", avatar: Avatars.categories[2].avatars[4], professions: []))
}
