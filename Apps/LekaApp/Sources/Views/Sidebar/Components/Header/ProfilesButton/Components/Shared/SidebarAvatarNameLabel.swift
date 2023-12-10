// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SidebarAvatarNameLabel: View {
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    let type: UserType

    var body: some View {
        Text(
            self.company.getProfileDataFor(
                self.type,
                id: self.company.profilesInUse[self.type]!
            )[1]
        )
        .font(self.metrics.reg15)
        .allowsTightening(true)
        .lineLimit(2)
        .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        .padding(.vertical, 2)
        .padding(.horizontal, 6)
        .frame(minWidth: 100)
        .background(.white, in: RoundedRectangle(cornerRadius: self.metrics.btnRadius))
    }
}

#Preview {
    SidebarAvatarNameLabel(type: .user)
}
