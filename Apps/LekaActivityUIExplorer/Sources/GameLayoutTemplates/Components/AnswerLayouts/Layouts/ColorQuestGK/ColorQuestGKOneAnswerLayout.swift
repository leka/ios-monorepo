// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ColorQuestGKOneAnswerLayout: View {

    @StateObject var templateDefaults: BaseDefaults = ColorQuest.one

    var body: some View {
        HStack {
            ColoredAnswerGKButton(templateDefaults: templateDefaults, index: 0)
        }
    }
}
