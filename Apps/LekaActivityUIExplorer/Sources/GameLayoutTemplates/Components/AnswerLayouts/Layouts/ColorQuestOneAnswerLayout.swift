// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ColorQuestOneAnswerLayout: View {
    var body: some View {
        HStack {
            Spacer()
            ColoredAnswerButton(answer: 0)
            Spacer()
        }
    }
}
