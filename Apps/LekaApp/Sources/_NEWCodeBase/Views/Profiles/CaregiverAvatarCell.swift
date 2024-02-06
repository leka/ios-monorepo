// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct CaregiverAvatarCell: View {
    // MARK: Internal

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared

    let caregiver: Caregiver

    var body: some View {
        Button {
            // TODO: (@team) - Add caregiver selection logic w/ Firebase
            self.rootOwnerViewModel.currentCaregiver = self.caregiver
            self.rootOwnerViewModel.isWelcomeViewPresented = false
        } label: {
            VStack(spacing: 10) {
                Image(self.caregiver.avatar, bundle: Bundle(for: DesignKitResources.self))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 140)

                Text(self.caregiver.name)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
            }
        }
    }
}

#Preview {
    CaregiverAvatarCell(caregiver: Caregiver(name: "Chantal", avatar: DesignKitAsset.Avatars.avatarsBoy4f.name, professions: []))
}
