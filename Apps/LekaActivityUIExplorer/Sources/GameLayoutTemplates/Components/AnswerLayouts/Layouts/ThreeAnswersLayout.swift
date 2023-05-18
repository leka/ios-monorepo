// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ThreeAnswersLayout: View {

    @StateObject var templateDefaults: BaseDefaults = TouchToSelect.three

    var body: some View {
        Grid(
            horizontalSpacing: templateDefaults.customHorizontalSpacing,
            verticalSpacing: templateDefaults.customVerticalSpacing
        ) {
            GridRow {
                CircularAnswerButton(templateDefaults: templateDefaults, answer: 0)
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                CircularAnswerButton(templateDefaults: templateDefaults, answer: 1)
            }
            GridRow {
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                CircularAnswerButton(templateDefaults: templateDefaults, answer: 2)
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
            }
        }
    }
}
