// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TeacherSidebarAvatarCell: View {

    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    SidebarAvatarView(type: .teacher)
                }
                .frame(height: settings.exploratoryModeIsOn ? 58 : 72)
                .offset(x: settings.exploratoryModeIsOn ? 26 : 0)
                .padding(10)

                if !settings.exploratoryModeIsOn {
                    SidebarAvatarNameLabel(type: .teacher)
                }
            }
            Spacer()
        }
    }
}

