// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct CommandListView: View {

    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var sidebar: SidebarViewModel

    private let images: [String] = [
        "standard-remote", "colored-arrows", "color-remote copy", "big-joystick", "hand-remote",
    ]

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()

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
                    if settings.companyIsConnected && !sidebar.showInfo() {
                        Color.clear
                            .frame(height: settings.companyIsConnected ? 40 : 0)
                    } else {
                        InfoTileManager()
                    }
                }
                Spacer()
            }
        }
        .animation(.easeOut(duration: 0.4), value: sidebar.showInfo())
        .onAppear { sidebar.sidebarVisibility = .all }
    }
}

struct CommandListView_Previews: PreviewProvider {
    static var previews: some View {
        CommandListView()
            .environmentObject(SidebarViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
    }
}
