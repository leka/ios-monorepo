// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ListenThreeAnswersLayout: View {

    @StateObject var templateDefaults: BaseDefaults = ListenThenTouchToSelect.three

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
                makeAnswer(0)
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                makeAnswer(1)
            }
            GridRow {
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                makeAnswer(2)
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
            }
        }
    }

    private func makeAnswer(_ answer: Int) -> some View {
        CircularAnswerButton(answer: answer)
            .frame(
                width: templateDefaults.customAnswerSize,
                height: templateDefaults.customAnswerSize
            )
    }
}
