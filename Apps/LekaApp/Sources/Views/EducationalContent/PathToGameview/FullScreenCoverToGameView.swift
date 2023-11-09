// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

struct FullScreenCoverToGameView: View {

    @EnvironmentObject var navigationVM: NavigationViewModel

    var body: some View {
        NavigationStack(path: $navigationVM.pathToGame) {
            EmptyView()
                .navigationDestination(
                    for: PathsToGame.self,
                    destination: { destination in
                        switch destination {
                            case .robot: RobotConnectionView()
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
            .environmentObject(NavigationViewModel())
    }
}
