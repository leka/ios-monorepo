// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ListenFourAnswersLayout: View {

    @StateObject var templateDefaults: BaseDefaults = ListenThenTouchToSelect.four

    var body: some View {
        HStack(spacing: 0) {
            PlaySoundButton()
                .padding(20)
            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)
            Spacer()
            answersLayout
            Spacer()
        }
    }

    private var answersLayout: some View {
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
