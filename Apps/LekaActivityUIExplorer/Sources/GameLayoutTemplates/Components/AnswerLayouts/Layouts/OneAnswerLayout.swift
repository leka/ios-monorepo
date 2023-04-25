// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct OneAnswerLayout: View {

    @EnvironmentObject var templateDefaults: DefaultsTemplateOne

    var body: some View {
        HStack {
            Spacer()
            CircularAnswerButton(answer: 0)
                .frame(
                    width: templateDefaults.playGridBtnSize,
                    height: templateDefaults.playGridBtnSize
                )
            Spacer()
        }
    }
}
