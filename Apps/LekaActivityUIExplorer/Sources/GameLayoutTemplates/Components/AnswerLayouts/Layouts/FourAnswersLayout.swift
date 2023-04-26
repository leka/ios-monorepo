// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FourAnswersLayout: View {

    @ObservedObject var templateDefaults: BaseDefaults

    var body: some View {
        Grid(
            horizontalSpacing: templateDefaults.customHorizontalSpacing,
            verticalSpacing: templateDefaults.customVerticalSpacing
        ) {
            GridRow {
                CircularAnswerButton(answer: 0)
                    .frame(
                        width: templateDefaults.customAnswerSize,
                        height: templateDefaults.customAnswerSize
                    )
                CircularAnswerButton(answer: 1)
                    .frame(
                        width: templateDefaults.customAnswerSize,
                        height: templateDefaults.customAnswerSize
                    )
            }
            GridRow {
                CircularAnswerButton(answer: 2)
                    .frame(
                        width: templateDefaults.customAnswerSize,
                        height: templateDefaults.customAnswerSize
                    )
                CircularAnswerButton(answer: 3)
                    .frame(
                        width: templateDefaults.customAnswerSize,
                        height: templateDefaults.customAnswerSize
                    )
            }
        }
    }
}
