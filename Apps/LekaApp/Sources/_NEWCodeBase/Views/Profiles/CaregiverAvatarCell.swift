// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import SwiftUI

struct CaregiverAvatarCell: View {
    // MARK: Internal

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared
    @ObservedObject private var authManagerViewModel = AuthManagerViewModel.shared

    let caregiver: Caregiver

    var body: some View {
        Button {
            // TODO: (@team) - Add caregiver selection logic w/ Firebase
            self.rootOwnerViewModel.currentCaregiver = self.caregiver
            self.styleManager.colorScheme = self.caregiver.preferredColorScheme
            self.styleManager.accentColor = self.caregiver.preferredAccentColor
            self.authManagerViewModel.isUserLoggedOut = false
            self.rootOwnerViewModel.isCaregiverPickerViewPresented = false
        } label: {
            VStack(spacing: 10) {
                Image(self.caregiver.avatar, bundle: Bundle(for: DesignKitResources.self))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 140)

                Text(self.caregiver.name)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    CaregiverAvatarCell(caregiver: Caregiver(name: "Chantal", avatar: DesignKitAsset.Avatars.avatarsBoy4f.name, professions: []))
}
