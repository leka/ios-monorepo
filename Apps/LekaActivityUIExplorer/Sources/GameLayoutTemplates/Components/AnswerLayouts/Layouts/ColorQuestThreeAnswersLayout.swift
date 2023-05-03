// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ColorQuestThreeAnswersLayout: View {

    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        HStack(spacing: defaults.horizontalCellSpacing) {
            ForEach(0..<3) { answer in
                ColoredAnswerButton(answer: answer)
            }
        }
    }
}
