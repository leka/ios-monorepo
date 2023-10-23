// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct TouchToSelectView: View {

    @StateObject private var viewModel: TouchToSelectViewViewModel

    let kHorizontalSpacing: CGFloat = 32
    let kAnswerSize: CGFloat = 300

    public init(choices: [SelectionChoice]) {
        self._viewModel = StateObject(wrappedValue: TouchToSelectViewViewModel(choices: choices))
    }

    public init(exercise: Exercise) {
        guard case .selection(let payload) = exercise.payload else {
            fatalError("Exercise payload is not .selection")
        }

        self._viewModel = StateObject(wrappedValue: TouchToSelectViewViewModel(choices: payload.choices))
    }

    public var body: some View {
        HStack(spacing: kHorizontalSpacing) {

            ForEach(viewModel.choices) { choice in
                ChoiceView(choice: choice.choice, state: choice.state, size: kAnswerSize)
                    .onTapGesture {
                        viewModel.onChoiceTapped(choice: choice)
                    }
            }
        }
    }

}
