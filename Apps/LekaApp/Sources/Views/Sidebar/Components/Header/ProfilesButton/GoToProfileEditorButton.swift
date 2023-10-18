// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct GoToProfileEditorButton: View {

    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModel

    var body: some View {
        Button {
            if settings.exploratoryModeIsOn {
                settings.showSwitchOffExploratoryAlert.toggle()
            } else {
                navigationVM.showProfileEditor.toggle()
            }
        } label: {
            VStack(spacing: 5) {
                HStack(alignment: .top) {
                    Spacer()
                    SidebarAvatarCell(type: .teacher)
                    SidebarAvatarCell(type: .user, badge: !settings.companyIsConnected)
                    Spacer()
                }
                .overlay(TickPic())

                if settings.exploratoryModeIsOn {
                    exploratoryModeLabel
                }
            }
        }
        .frame(minHeight: 135)
        .contentShape(Rectangle())
        .animation(.default, value: settings.exploratoryModeIsOn)
    }

    private var exploratoryModeLabel: some View {
        Text("Mode exploratoire")
            .font(metrics.reg17)
            .foregroundColor(Color("lekaSkyBlue"))
            .padding(.vertical, 2)
            .padding(.horizontal, 6)
            .background(.white, in: RoundedRectangle(cornerRadius: metrics.btnRadius))
    }
}

struct GoToProfileEditorButton_Previews: PreviewProvider {
    static var previews: some View {
        GoToProfileEditorButton()
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
            .environmentObject(NavigationViewModel())
    }
}
