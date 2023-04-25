// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ThreeAnswersLayoutInline: View {

    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @StateObject var templateDefaults = DefaultsTemplateThreeInline()

    var body: some View {
        HStack(spacing: defaults.horizontalCellSpacing) {
            ForEach(0..<3) { answer in
                CircularAnswerButton(answer: answer)
                    .frame(
                        width: templateDefaults.playGridBtnSize,
                        height: templateDefaults.playGridBtnSize
                    )
            }
        }
    }
}
