// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FourAnswersLayout: View {

    @EnvironmentObject var templateDefaults: DefaultsTemplateFour

    var body: some View {
        Grid(
            horizontalSpacing: templateDefaults.horizontalCellSpacing,
            verticalSpacing: templateDefaults.verticalCellSpacing
        ) {
            GridRow {
                CircularAnswerButton(answer: 0)
                    .frame(
                        width: templateDefaults.playGridBtnSize,
                        height: templateDefaults.playGridBtnSize
                    )
                CircularAnswerButton(answer: 1)
                    .frame(
                        width: templateDefaults.playGridBtnSize,
                        height: templateDefaults.playGridBtnSize
                    )
            }
            GridRow {
                CircularAnswerButton(answer: 2)
                    .frame(
                        width: templateDefaults.playGridBtnSize,
                        height: templateDefaults.playGridBtnSize
                    )
                CircularAnswerButton(answer: 3)
                    .frame(
                        width: templateDefaults.playGridBtnSize,
                        height: templateDefaults.playGridBtnSize
                    )
            }
        }
    }
}
