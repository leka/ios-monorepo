// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - TTSChoiceModel

struct TTSChoiceModel: Identifiable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, value: String, state: TTSChoiceState = .idle) {
        self.id = id
        self.value = value
        self.state = state
    }

    // MARK: Internal

    let id: String
    let value: String
    let state: TTSChoiceState
}

// MARK: - TTSChoiceState

enum TTSChoiceState {
    case idle
    case selected
    case correct
    case wrong
}

// MARK: - TTSChoiceView

struct TTSChoiceView: View {
    var choice: TTSChoiceModel

    var body: some View {
        Circle()
            .fill(Color.lkBackground)
            .badge(10)
            .frame(
                width: 220,
                height: 220
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
            .badge(10)
            .overlay {
                Text(self.choice.value)
                    .multilineTextAlignment(.center)
                    .bold()
                    .badge(10)
            }
            .overlay {
                TTSChoiceStateBadge(state: self.choice.state)
            }
    }
}

// MARK: - TTSChoiceStateBadge

struct TTSChoiceStateBadge: View {
    let state: TTSChoiceState

    var body: some View {
        ZStack {
            switch self.state {
                case .correct:
                    Image(systemName: "checkmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .position(x: 200, y: 20)
                case .selected:
                    Image(systemName: "circle.dotted.circle")
                        .font(.largeTitle)
                        .foregroundColor(.teal)
                        .position(x: 200, y: 20)
                case .wrong:
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .position(x: 200, y: 20)
                case .idle:
                    EmptyView()
            }
        }
        .opacity(self.state == .idle ? 0 : 1)
    }
}
