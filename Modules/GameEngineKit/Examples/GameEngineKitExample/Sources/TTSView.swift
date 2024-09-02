// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - TTSViewViewModel

class TTSViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(choices: [TTSChoiceModel]) {
        self.choices = choices
    }

    // MARK: Internal

    @Published var choices: [TTSChoiceModel]

    func onTappped(choice: TTSChoiceModel) {
        print("[VM] Tapped: \(choice.id) - \(choice.value.replacingOccurrences(of: "\n", with: " ")) - \(choice.state)")
    }
}

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

// MARK: - TTSView

struct TTSView: View {
    // MARK: Lifecycle

    init(viewModel: TTSViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Internal

    @StateObject var viewModel: TTSViewViewModel

    var body: some View {
        VStack(spacing: 100) {
            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[0...2]) { choice in
                    TTSChoiceView(choice: choice)
                        .onTapGesture {
                            self.viewModel.onTappped(choice: choice)
                        }
                }
            }

            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[3...5]) { choice in
                    TTSChoiceView(choice: choice)
                        .onTapGesture {
                            self.viewModel.onTappped(choice: choice)
                        }
                }
            }
        }
    }
}

#Preview {
    let choices = [
        TTSChoiceModel(value: "Choice 1", state: .idle),
        TTSChoiceModel(value: "Choice 2\nSelected", state: .selected),
        TTSChoiceModel(value: "Choice 3\nCorrect", state: .correct),
        TTSChoiceModel(value: "Choice 4\nWrong", state: .wrong),
        TTSChoiceModel(value: "Choice 5"),
        TTSChoiceModel(value: "Choice 6"),
    ]

    return TTSView(viewModel: TTSViewViewModel(choices: choices))
}
