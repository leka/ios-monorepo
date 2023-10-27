// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct UserSidebarAvatarCell: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    SidebarAvatarView(type: .user)
                    avatarAccessoryView
                }
                .frame(height: settings.exploratoryModeIsOn ? 58 : 72)
                .offset(x: settings.exploratoryModeIsOn ? -26 : 0)
                .padding(10)

                if !settings.exploratoryModeIsOn {
                    SidebarAvatarNameLabel(type: .user)
                }
            }
            Spacer()
        }
    }

    @ViewBuilder private var avatarAccessoryView: some View {
        if !settings.companyIsConnected || (!company.profileIsAssigned(.user) && !settings.exploratoryModeIsOn) {
            Image(systemName: "exclamationmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .red)
                .font(metrics.reg19)
                .frame(maxWidth: 22, maxHeight: 22)
                .offset(x: 2, y: -2)
        } else if company.profileIsAssigned(.user) {
            Image("reinforcer-\(company.getCurrentUserReinforcer())")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: settings.exploratoryModeIsOn ? 24 : 33)
                .background(.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .fill(.black)
                        .opacity(settings.exploratoryModeIsOn ? 0.3 : 0)
                )
                .overlay(Circle().stroke(.white, lineWidth: 3))
                .offset(x: 6, y: settings.exploratoryModeIsOn ? -8 : -12)
        }
    }
}
