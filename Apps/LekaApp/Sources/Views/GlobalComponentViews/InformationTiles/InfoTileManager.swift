// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct InfoTileManager: View {
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        Group {
            if !self.settings.companyIsConnected {
                HStack(spacing: 15) {
                    InfoTile(data: .discovery)
                    InfoTile(data: self.navigationVM.contextualInfo())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            } else if self.navigationVM.showInfo() {
                InfoTile(data: self.navigationVM.contextualInfo())
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
