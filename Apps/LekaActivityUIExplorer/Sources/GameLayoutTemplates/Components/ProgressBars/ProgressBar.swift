// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ProgressBar: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        HStack {
            Spacer()
            ForEach(gameEngine.groupedStepMarkerColors.indices, id: \.self) { group in
                HStack {
                    ForEach(gameEngine.groupedStepMarkerColors[group].indices, id: \.self) { step in
                        StepMarker(color: .constant(gameEngine.groupedStepMarkerColors[group][step]))
                        if step < gameEngine.groupedStepMarkerColors[group].count - 1 {
                            Spacer().frame(minWidth: 20, maxWidth: 60)
                        }
                    }
                }
                .background(defaults.progressBarBackgroundColor, in: Capsule())
                if group < gameEngine.groupedStepMarkerColors.count - 1 {
                    Spacer().frame(maxWidth: 100)
                }
            }
            .frame(maxHeight: defaults.progressBarHeight)
            Spacer()
        }
    }
}
