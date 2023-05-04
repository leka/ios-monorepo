// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SixAnswersLayout: View {

    @ObservedObject var templateDefaults: BaseDefaults

    var body: some View {
        Grid(
            horizontalSpacing: templateDefaults.customHorizontalSpacing,
            verticalSpacing: templateDefaults.customVerticalSpacing
        ) {
            GridRow {
                ForEach(0..<3) { answer in
                    CircularAnswerButton(answer: answer)
                        .frame(
                            width: templateDefaults.customAnswerSize,
                            height: templateDefaults.customAnswerSize
                        )
                }
            }
            GridRow {
                ForEach(3..<6) { answer in
                    CircularAnswerButton(answer: answer)
                        .frame(
                            width: templateDefaults.customAnswerSize,
                            height: templateDefaults.customAnswerSize
                        )
                }
            }
        }
    }
}
