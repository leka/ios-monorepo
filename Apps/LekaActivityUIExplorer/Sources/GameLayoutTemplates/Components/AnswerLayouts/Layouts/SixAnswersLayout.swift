// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SixAnswersLayout: View {

    @StateObject var templateDefaults: BaseDefaults = TouchToSelect.six

    var body: some View {
        Grid(
            horizontalSpacing: templateDefaults.customHorizontalSpacing,
            verticalSpacing: templateDefaults.customVerticalSpacing
        ) {
            GridRow {
                ForEach(0..<3) { answer in
                    CircularAnswerButton(templateDefaults: templateDefaults, answer: answer)
                }
            }
            GridRow {
                ForEach(3..<6) { answer in
                    CircularAnswerButton(templateDefaults: templateDefaults, answer: answer)
                }
            }
        }
    }
}
