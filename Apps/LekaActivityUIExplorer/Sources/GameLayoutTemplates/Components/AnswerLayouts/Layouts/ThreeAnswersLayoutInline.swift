// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ThreeAnswersLayoutInline: View {

    @StateObject var templateDefaults: BaseDefaults = TouchToSelect.threeInline

    var body: some View {
        HStack(spacing: templateDefaults.customHorizontalSpacing) {
            ForEach(0..<3) { answer in
                CircularAnswerButton(templateDefaults: templateDefaults, answer: answer)
            }
        }
    }
}
