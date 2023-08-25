// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct XylophoneLayout: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @StateObject var xylophoneDefaults: XylophoneDefaults = Misc.xylophone

    var body: some View {
        HStack(spacing: xylophoneDefaults.customTilesSpacing) {
            ForEach(xylophoneDefaults.customTileColors.indices, id: \.self) { index in
                XylophoneTile(xylophoneDefaults: xylophoneDefaults, index: index)
            }
        }
        .alertWhenRobotIsNeeded()
    }
}
