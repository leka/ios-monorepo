// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ColorQuestTwoAnswersLayout: View {

    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        HStack(spacing: defaults.horizontalCellSpacing) {
            ForEach(0..<2) { answer in
                ColoredAnswerButton(answer: answer)
            }
        }
    }
}
