// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct MelodyLayout: View {
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @StateObject var xylophoneDefaults: XylophoneDefaults = Melody.one

    @State private var progress = 0.0

    var body: some View {
        VStack {
            ContinuousProgressBar(progress: progress)
                .padding(.horizontal, 30)

            HStack(spacing: xylophoneDefaults.customTilesSpacing) {
                ForEach(xylophoneDefaults.customTileColors.indices, id: \.self) { index in
                    XylophoneTile(xylophoneDefaults: xylophoneDefaults, index: index)
                }
            }
            .alertWhenRobotIsNeeded()
        }
        .padding()

    }
}

struct MelodyLayout_Previews: PreviewProvider {
    static var previews: some View {
        MelodyLayout()
            .environmentObject(GameEngine())
            .environmentObject(GameLayoutTemplatesDefaults())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
