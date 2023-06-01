// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ProgressBarGK: View {

    @EnvironmentObject var gameEngineGK: GameEngineGK
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        HStack {
            Spacer()
            ForEach(gameEngineGK.groupedStepMarkerColors.indices, id: \.self) { group in
                HStack {
                    ForEach(gameEngineGK.groupedStepMarkerColors[group].indices, id: \.self) { step in
                        StepMarker(color: .constant(gameEngineGK.groupedStepMarkerColors[group][step]))
                        if step < gameEngineGK.groupedStepMarkerColors[group].count - 1 {
                            Spacer().frame(minWidth: 20, maxWidth: 60)
                        }
                    }
                }
                .background(defaults.progressBarBackgroundColor, in: Capsule())
                if group < gameEngineGK.groupedStepMarkerColors.count - 1 {
                    Spacer().frame(maxWidth: 100)
                }
            }
            .frame(maxHeight: defaults.progressBarHeight)
            Spacer()
        }
    }
}
