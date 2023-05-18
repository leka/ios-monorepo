// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FourAnswersLayout: View {

    @StateObject var templateDefaults: BaseDefaults = TouchToSelect.four

    var body: some View {
        Grid(
            horizontalSpacing: templateDefaults.customHorizontalSpacing,
            verticalSpacing: templateDefaults.customVerticalSpacing
        ) {
            GridRow {
                CircularAnswerButton(templateDefaults: templateDefaults, answer: 0)
                CircularAnswerButton(templateDefaults: templateDefaults, answer: 1)
            }
            GridRow {
                CircularAnswerButton(templateDefaults: templateDefaults, answer: 2)
                CircularAnswerButton(templateDefaults: templateDefaults, answer: 3)
            }
        }
    }
}
