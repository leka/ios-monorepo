//
//  PathToGameView.swift
//  LekaApp
//
//  Created by Mathieu Jeannot on 11/9/23.
//  Copyright © 2023 leka.io. All rights reserved.
//

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
