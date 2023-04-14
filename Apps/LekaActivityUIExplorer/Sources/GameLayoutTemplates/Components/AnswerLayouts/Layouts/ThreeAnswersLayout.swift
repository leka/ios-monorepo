// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ThreeAnswersLayout: View {

    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        Grid(horizontalSpacing: defaults.horizontalCellSpacing, verticalSpacing: defaults.verticalCellSpacing) {
            GridRow {
                CircularAnswerButton(answer: 0)
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                CircularAnswerButton(answer: 1)
            }
            GridRow {
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                CircularAnswerButton(answer: 2)
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
            }
        }
    }
}
