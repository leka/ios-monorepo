// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ListenOneAnswerLayout: View {

    @StateObject var templateDefaults: BaseDefaults = ListenThenTouchToSelect.one

    var body: some View {
        HStack(spacing: 0) {
            PlaySoundButton()
                .padding(20)
            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)
            Spacer()
            answersLayout
            Spacer()
        }
    }

    private var answersLayout: some View {
        CircularAnswerButton(answer: 0)
            .frame(
                width: templateDefaults.customAnswerSize,
                height: templateDefaults.customAnswerSize
            )
    }
}
