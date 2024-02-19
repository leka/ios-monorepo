// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - GoToProfileEditorButtonDeprecated

struct GoToProfileEditorButtonDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var settings: SettingsViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModelDeprecated

    var body: some View {
        Button {
            if self.settings.exploratoryModeIsOn {
                self.settings.showSwitchOffExploratoryAlert.toggle()
            } else {
                self.navigationVM.showProfileEditor.toggle()
            }
        } label: {
            VStack(spacing: 5) {
                HStack(alignment: .top) {
                    Spacer()
                    TeacherSidebarAvatarCell()
                    UserSidebarAvatarCell()
                    Spacer()
                }
                .overlay(TickPic())

                if self.settings.exploratoryModeIsOn {
                    self.exploratoryModeLabel
                }
            }
        }
        .frame(minHeight: 135)
        .contentShape(Rectangle())
        .animation(.default, value: self.settings.exploratoryModeIsOn)
    }

    // MARK: Private

    private var exploratoryModeLabel: some View {
        Text("Mode exploratoire")
            .font(.body)
            .foregroundColor(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
            .padding(.vertical, 2)
            .padding(.horizontal, 6)
            .background(.white, in: RoundedRectangle(cornerRadius: self.metrics.btnRadius))
    }
}

// MARK: - GoToProfileEditorButton_Previews

struct GoToProfileEditorButton_Previews: PreviewProvider {
    static var previews: some View {
        GoToProfileEditorButtonDeprecated()
            .environmentObject(SettingsViewModelDeprecated())
            .environmentObject(UIMetrics())
            .environmentObject(NavigationViewModelDeprecated())
    }
}
