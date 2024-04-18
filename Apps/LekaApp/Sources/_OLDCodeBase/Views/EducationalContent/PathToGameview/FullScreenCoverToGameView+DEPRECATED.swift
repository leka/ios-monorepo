// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

// MARK: - FullScreenCoverToGameViewDeprecated

struct FullScreenCoverToGameViewDeprecated: View {
    @EnvironmentObject var navigationVM: NavigationViewModelDeprecated

    var body: some View {
        NavigationStack(path: self.$navigationVM.pathToGame) {
            EmptyView()
                .navigationDestination(
                    for: PathsToGame.self,
                    destination: { destination in
                        switch destination {
                            case .robot: RobotConnectionView()
                            case .user: ProfileSelector_UsersDeprecated()
                            case .game: GameViewDeprecated()
                        }
                    }
                )
        }
    }
}

// MARK: - FullScreenCoverToGameView_Previews

struct FullScreenCoverToGameView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenCoverToGameViewDeprecated()
            .environmentObject(NavigationViewModelDeprecated())
    }
}
