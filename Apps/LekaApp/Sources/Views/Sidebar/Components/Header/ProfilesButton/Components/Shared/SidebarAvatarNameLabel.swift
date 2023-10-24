// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SidebarAvatarNameLabel: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    let type: UserType

    var body: some View {
        Text(
            company.getProfileDataFor(
                type,
                id: company.profilesInUse[type]!
            )[1]
        )
        .font(metrics.reg15)
        .allowsTightening(true)
        .lineLimit(2)
        .foregroundColor(.accentColor)
        .padding(.vertical, 2)
        .padding(.horizontal, 6)
        .frame(minWidth: 100)
        .background(.white, in: RoundedRectangle(cornerRadius: metrics.btnRadius))
    }
}

#Preview {
    SidebarAvatarNameLabel(type: .user)
}
