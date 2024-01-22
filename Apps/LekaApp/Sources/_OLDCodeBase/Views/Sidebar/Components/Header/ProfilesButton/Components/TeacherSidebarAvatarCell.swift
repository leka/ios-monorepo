// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TeacherSidebarAvatarCell: View {
    @EnvironmentObject var settings: SettingsViewModelDeprecated

    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    SidebarAvatarView(type: .teacher)
                }
                .frame(height: self.settings.exploratoryModeIsOn ? 58 : 72)
                .offset(x: self.settings.exploratoryModeIsOn ? 26 : 0)
                .padding(10)

                if !self.settings.exploratoryModeIsOn {
                    SidebarAvatarNameLabel(type: .teacher)
                }
            }
            Spacer()
        }
    }
}
