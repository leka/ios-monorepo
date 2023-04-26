// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SixAnswersLayout: View {

    @EnvironmentObject var templateDefaults: DefaultsTemplateSix

    var body: some View {
        Grid(
            horizontalSpacing: templateDefaults.horizontalCellSpacing,
            verticalSpacing: templateDefaults.verticalCellSpacing
        ) {
            GridRow {
                ForEach(0..<3) { answer in
                    CircularAnswerButton(answer: answer)
                        .frame(
                            width: templateDefaults.playGridBtnSize,
                            height: templateDefaults.playGridBtnSize
                        )
                }
            }
            GridRow {
                ForEach(3..<6) { answer in
                    CircularAnswerButton(answer: answer)
                        .frame(
                            width: templateDefaults.playGridBtnSize,
                            height: templateDefaults.playGridBtnSize
                        )
                }
            }
        }
    }
}
