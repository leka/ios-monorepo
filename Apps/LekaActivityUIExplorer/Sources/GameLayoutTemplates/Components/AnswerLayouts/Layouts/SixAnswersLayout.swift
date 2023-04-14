// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SixAnswersLayout: View {

    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        Grid(horizontalSpacing: defaults.horizontalCellSpacing, verticalSpacing: defaults.verticalCellSpacing) {
            GridRow {
                ForEach(0..<3) { answer in
                    CircularAnswerButton(answer: answer)
                }
            }
            GridRow {
                ForEach(3..<6) { answer in
                    CircularAnswerButton(answer: answer)
                }
            }
        }
    }
}
