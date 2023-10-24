// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TeacherSidebarAvatarCell: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 0) {
                avatarView
                nameLabel
            }
            Spacer()
        }
    }

    private var avatarView: some View {
        ZStack(alignment: .topTrailing) {
            Circle()
                .fill(Color.accentColor)
                .overlay(
                    Image(
                        company.getProfileDataFor(
                            .teacher,
                            id: company.profilesInUse[.teacher]!
                        )[0]
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
        .frame(height: settings.exploratoryModeIsOn ? 58 : 72)
        .offset(x: settings.exploratoryModeIsOn ? 26 : 0)
        .padding(10)
    }

    @ViewBuilder private var nameLabel: some View {
        if !settings.exploratoryModeIsOn {
            Text(
                company.getProfileDataFor(
                    .teacher,
                    id: company.profilesInUse[.teacher]!
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
}

