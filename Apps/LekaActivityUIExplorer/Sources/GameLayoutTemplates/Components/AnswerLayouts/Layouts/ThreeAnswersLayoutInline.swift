// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ThreeAnswersLayoutInline: View {

    @ObservedObject var templateDefaults: BaseDefaults

    var body: some View {
        HStack(spacing: templateDefaults.customHorizontalSpacing) {
            ForEach(0..<3) { answer in
                CircularAnswerButton(answer: answer)
                    .frame(
                        width: templateDefaults.customAnswerSize,
                        height: templateDefaults.customAnswerSize
                    )
            }
        }
    }
}
