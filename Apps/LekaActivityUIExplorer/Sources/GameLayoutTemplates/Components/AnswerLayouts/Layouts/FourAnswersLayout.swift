// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FourAnswersLayout: View {

    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        Grid(horizontalSpacing: defaults.horizontalCellSpacing, verticalSpacing: defaults.verticalCellSpacing) {
            GridRow {
                CircularAnswerButton(answer: 0)
                CircularAnswerButton(answer: 1)
            }
            GridRow {
                CircularAnswerButton(answer: 2)
                CircularAnswerButton(answer: 3)
            }
        }
    }
}
