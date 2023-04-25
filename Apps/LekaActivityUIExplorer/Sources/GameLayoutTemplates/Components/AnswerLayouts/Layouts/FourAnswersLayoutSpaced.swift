// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FourAnswersLayoutSpaced: View {

    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    // TODO: (@Macteuts) - Update this when this view is used (defaults etc...)

    var body: some View {
        Grid(horizontalSpacing: defaults.horizontalCellSpacing, verticalSpacing: defaults.verticalCellSpacing) {
            GridRow {
                CircularAnswerButton(answer: 0)
                Color.clear.frame(width: defaults.playGridBtnSize, height: 0)
                CircularAnswerButton(answer: 1)
            }
            GridRow {
                CircularAnswerButton(answer: 2)
                Color.clear.frame(width: defaults.playGridBtnSize, height: 0)
                CircularAnswerButton(answer: 3)
            }
        }
    }
}
