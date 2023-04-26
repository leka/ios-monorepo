// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FiveAnswersLayout: View {

    @EnvironmentObject var templateDefaults: DefaultsTemplateFive

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
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                CircularAnswerButton(answer: 1)
                    .frame(
                        width: templateDefaults.playGridBtnSize,
                        height: templateDefaults.playGridBtnSize
                    )
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                CircularAnswerButton(answer: 2)
                    .frame(
                        width: templateDefaults.playGridBtnSize,
                        height: templateDefaults.playGridBtnSize
                    )
            }
            GridRow {
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                CircularAnswerButton(answer: 3)
                    .frame(
                        width: templateDefaults.playGridBtnSize,
                        height: templateDefaults.playGridBtnSize
                    )
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                CircularAnswerButton(answer: 4)
                    .frame(
                        width: templateDefaults.playGridBtnSize,
                        height: templateDefaults.playGridBtnSize
                    )
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
            }
        }
    }
}
