// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FullScreenCoverToGameView: View {

    @EnvironmentObject var sidebar: SidebarViewModel

    var body: some View {
        NavigationStack(path: $sidebar.pathToGame) {
            EmptyView()
                .navigationDestination(
                    for: PathsToGame.self,
                    destination: { destination in
                        switch destination {
                            case .robot: RobotPicker()
                            case .user: ProfileSelector_Users()
                            case .game: GameView()
                        }
                    }
                )
        }
    }
}

struct FullScreenCoverToGameView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenCoverToGameView()
            .environmentObject(SidebarViewModel())
    }
}
