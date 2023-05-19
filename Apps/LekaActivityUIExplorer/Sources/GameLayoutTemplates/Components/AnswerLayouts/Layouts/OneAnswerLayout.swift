// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct OneAnswerLayout: View {

    @StateObject var templateDefaults: BaseDefaults = TouchToSelect.one

    var body: some View {
        HStack {
            Spacer()
            CircularAnswerButton(templateDefaults: templateDefaults, answer: 0)
            Spacer()
        }
    }
}
