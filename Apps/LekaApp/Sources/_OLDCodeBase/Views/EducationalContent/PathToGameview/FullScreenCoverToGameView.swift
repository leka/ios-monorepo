// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

// MARK: - FullScreenCoverToGameView

struct FullScreenCoverToGameView: View {
    @EnvironmentObject var navigationVM: NavigationViewModel

    var body: some View {
        NavigationStack(path: self.$navigationVM.pathToGame) {
            EmptyView()
                .navigationDestination(
                    for: PathsToGame.self,
                    destination: { destination in
                        switch destination {
                            case .robot: RobotConnectionView()
                            case .user: ProfileSelector_UsersDeprecated()
                            case .game: GameView()
                        }
                    }
                )
        }
    }
}

// MARK: - FullScreenCoverToGameView_Previews

struct FullScreenCoverToGameView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenCoverToGameView()
            .environmentObject(NavigationViewModel())
    }
}
