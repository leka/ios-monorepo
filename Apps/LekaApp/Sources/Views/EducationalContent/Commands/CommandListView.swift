// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct CommandListView: View {

    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var navigationVM: NavigationViewModel

    private let images: [String] = [
        "standard-remote", "colored-arrows", "color-remote copy", "big-joystick", "hand-remote",
    ]

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

            let columns = Array(repeating: GridItem(), count: 3)
            VStack {
                LazyVGrid(columns: columns) {
                    ForEach(images.indices, id: \.self) { item in
                        Image(images[item])
                            .activityIconImageModifier(padding: 20)
                            .padding()
                    }
                }
                .safeAreaInset(edge: .top) {
                    if settings.companyIsConnected && !navigationVM.showInfo() {
                        Color.clear
                            .frame(height: settings.companyIsConnected ? 40 : 0)
                    } else {
                        InfoTileManager()
                    }
                }
                Spacer()
            }
        }
        .animation(.easeOut(duration: 0.4), value: navigationVM.showInfo())
        .onAppear { navigationVM.sidebarVisibility = .all }
    }
}

struct CommandListView_Previews: PreviewProvider {
    static var previews: some View {
        CommandListView()
            .environmentObject(NavigationViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
    }
}
