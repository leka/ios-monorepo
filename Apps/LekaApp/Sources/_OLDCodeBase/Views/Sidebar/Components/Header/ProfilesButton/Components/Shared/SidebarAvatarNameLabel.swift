// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SidebarAvatarNameLabel: View {
    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    let type: UserTypeDeprecated

    var body: some View {
        Text(
            self.company.getProfileDataFor(
                self.type,
                id: self.company.profilesInUse[self.type]!
            )[1]
        )
        // TODO: (@ui/ux) - Design System - replace with Leka font
        .font(.subheadline)
        .allowsTightening(true)
        .lineLimit(2)
        .padding(.vertical, 2)
        .padding(.horizontal, 6)
        .frame(minWidth: 100)
        .background(.white, in: RoundedRectangle(cornerRadius: self.metrics.btnRadius))
    }
}

#Preview {
    SidebarAvatarNameLabel(type: .user)
}
