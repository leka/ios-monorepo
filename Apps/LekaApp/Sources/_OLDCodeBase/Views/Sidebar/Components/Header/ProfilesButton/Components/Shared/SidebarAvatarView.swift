// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SidebarAvatarView: View {
    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var settings: SettingsViewModelDeprecated

    let type: UserTypeDeprecated

    var body: some View {
        Circle()
            .fill(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
            .overlay(
                Image(
                    self.company.getProfileDataFor(
                        self.type,
                        id: self.company.profilesInUse[self.type]!
                    )[0],
                    bundle: Bundle(for: DesignKitResources.self)
                )
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            )
            .overlay(
                Circle()
                    .fill(.black)
                    .opacity(self.settings.exploratoryModeIsOn ? 0.3 : 0)
            )
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 4)
            }
    }
}

#Preview {
    SidebarAvatarView(type: .teacher)
}
