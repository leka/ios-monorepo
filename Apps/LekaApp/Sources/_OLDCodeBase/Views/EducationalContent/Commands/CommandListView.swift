// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CommandListView

struct CommandListView: View {
    // MARK: Internal

    @EnvironmentObject var settings: SettingsViewModelDeprecated
    @EnvironmentObject var navigationVM: NavigationViewModel

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

            let columns = Array(repeating: GridItem(), count: 3)
            VStack {
                LazyVGrid(columns: columns) {
                    ForEach(self.images.indices, id: \.self) { item in
                        Image(self.images[item])
                            .activityIconImageModifier(padding: 20)
                            .padding()
                    }
                }
                .safeAreaInset(edge: .top) {
                    if self.settings.companyIsConnected, !self.navigationVM.showInfo() {
                        Color.clear
                            .frame(height: self.settings.companyIsConnected ? 40 : 0)
                    } else {
                        InfoTileManager()
                    }
                }
                Spacer()
            }
        }
        .animation(.easeOut(duration: 0.4), value: self.navigationVM.showInfo())
        .onAppear { self.navigationVM.sidebarVisibility = .all }
    }

    // MARK: Private

    private let images: [String] = [
        "standard-remote", "colored-arrows", "color-remote copy", "big-joystick", "hand-remote",
    ]
}

// MARK: - CommandListView_Previews

struct CommandListView_Previews: PreviewProvider {
    static var previews: some View {
        CommandListView()
            .environmentObject(NavigationViewModel())
            .environmentObject(SettingsViewModelDeprecated())
            .environmentObject(UIMetrics())
    }
}
