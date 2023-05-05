// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ColorQuestOneAnswerLayout: View {

    @ObservedObject var templateDefaults: BaseDefaults

    var body: some View {
        HStack {
            ColoredAnswerButton(answer: 0)
                .frame(
                    width: templateDefaults.customAnswerSize,
                    height: templateDefaults.customAnswerSize
                )
        }
    }
}
