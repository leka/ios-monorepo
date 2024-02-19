// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct InfoTileManagerDeprecated: View {
    @EnvironmentObject var navigationVM: NavigationViewModelDeprecated
    @EnvironmentObject var settings: SettingsViewModelDeprecated

    var body: some View {
        Group {
            if !self.settings.companyIsConnected {
                HStack(spacing: 15) {
                    InfoTileDeprecated(data: .discovery)
                    InfoTileDeprecated(data: self.navigationVM.contextualInfo())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            } else if self.navigationVM.showInfo() {
                InfoTileDeprecated(data: self.navigationVM.contextualInfo())
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            } else {
                EmptyView()
            }
        }
        .animation(.easeOut(duration: 0.4), value: self.navigationVM.showInfo())
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}
