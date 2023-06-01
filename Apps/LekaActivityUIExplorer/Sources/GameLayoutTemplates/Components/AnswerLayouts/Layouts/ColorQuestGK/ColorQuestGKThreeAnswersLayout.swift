// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ColorQuestGKThreeAnswersLayout: View {
//	@EnvironmentObject var gameEngineGK: GameEngineGK
    @StateObject var templateDefaults: BaseDefaults = ColorQuest.three

    var body: some View {
        HStack(spacing: templateDefaults.customHorizontalSpacing) {
            ForEach(0..<3) { answer in
                ColoredAnswerGKButton(templateDefaults: templateDefaults, index: answer)
            }
        }
    }
}
