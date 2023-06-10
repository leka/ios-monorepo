// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ReinforcerView: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        LottieView(
            name: "motivator", speed: 0.5,
            action: { gameEngine.hideMotivator() },
            play: $gameEngine.showMotivator
        )
        .scaleEffect(defaults.motivatorScale, anchor: .center)
    }
}
