// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SidebarAvatarView: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel

    let type: UserType

    var body: some View {
        Circle()
            .fill(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
            .overlay(
                Image(
                    company.getProfileDataFor(
                        type,
                        id: company.profilesInUse[type]!
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
                    .opacity(settings.exploratoryModeIsOn ? 0.3 : 0)
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
