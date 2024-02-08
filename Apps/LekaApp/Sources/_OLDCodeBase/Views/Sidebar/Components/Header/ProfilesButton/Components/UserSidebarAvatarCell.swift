// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct UserSidebarAvatarCell: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var settings: SettingsViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    SidebarAvatarView(type: .user)
                    self.avatarAccessoryView
                }
                .frame(height: self.settings.exploratoryModeIsOn ? 58 : 72)
                .offset(x: self.settings.exploratoryModeIsOn ? -26 : 0)
                .padding(10)

                if !self.settings.exploratoryModeIsOn {
                    SidebarAvatarNameLabel(type: .user)
                }
            }
            Spacer()
        }
    }

    // MARK: Private

    @ViewBuilder private var avatarAccessoryView: some View {
        if !self.settings.companyIsConnected || (!self.company.profileIsAssigned(.user) && !self.settings.exploratoryModeIsOn) {
            Image(systemName: "exclamationmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .red)
                .font(.title)
                .frame(maxWidth: 22, maxHeight: 22)
                .offset(x: 2, y: -2)
        } else if self.company.profileIsAssigned(.user) {
            Image(uiImage: self.company.getReinforcerFor(index: self.company.getCurrentUserReinforcer()))
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: self.settings.exploratoryModeIsOn ? 24 : 33)
                .background(.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .fill(.black)
                        .opacity(self.settings.exploratoryModeIsOn ? 0.3 : 0)
                )
                .overlay(Circle().stroke(.white, lineWidth: 3))
                .offset(x: 6, y: self.settings.exploratoryModeIsOn ? -8 : -12)
        }
    }
}
