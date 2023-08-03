// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ChoiceView: View {
    var choice: ChoiceViewModel
    let size: CGFloat

    var body: some View {
        switch choice.type {
            case .color:
                ColoredAnswerView(color: choice.item, size: size, status: choice.status)
            case .image:
                ImageAnswerView(image: choice.item, size: size, status: choice.status)
            case .text:
                TextAnswerView(text: choice.item, size: size, status: choice.status)
        }
    }
}
