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
            Image(self.caregiver.avatar, bundle: Bundle(for: DesignKitResources.self))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())

            Text(self.caregiver.name)
                .font(.headline)
        }
    }
}

#Preview {
    CaregiverAvatarCell(caregiver: Caregiver(name: "Chantal", avatar: DesignKitAsset.Avatars.avatarsBoy4f.name, professions: []))
}
