// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSView

struct TTSThenValidateView: View {
    // MARK: Lifecycle

    init(viewModel: TTSThenValidateViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Internal

    @StateObject var viewModel: TTSThenValidateViewViewModel

    var body: some View {
        VStack(spacing: 100) {
            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[0...2]) { choice in
                    TTSChoiceView(choice: choice)
                        .onTapGesture {
                            self.viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }

            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[3...5]) { choice in
                    TTSChoiceView(choice: choice)
                        .onTapGesture {
                            self.viewModel.onChoiceTapped(choice: choice)
                        }
                }
            }

            Button("Validate") {
                self.viewModel.onValidate()
            }
            .tint(.green)
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    // MARK: - TTSEmptyCoordinator

    class TTSEmptyCoordinator: TTSThenValidateGameplayCoordinatorProtocol {
        var uiChoices = CurrentValueSubject<[TTSChoiceModel], Never>([
            TTSChoiceModel(value: "Choice 1", state: .idle),
            TTSChoiceModel(value: "Choice 2\nSelected", state: .selected()),
            TTSChoiceModel(value: "Choice 3\nCorrect", state: .correct()),
            TTSChoiceModel(value: "Choice 4\nWrong", state: .wrong),
            TTSChoiceModel(value: "Choice 5"),
            TTSChoiceModel(value: "Choice 6"),
        ])

        func processUserSelection(choice: TTSChoiceModel) {
            log.debug("\(choice.id) - \(choice.value.replacingOccurrences(of: "\n", with: " ")) - \(choice.state)")
        }

        func validateUserSelection() {
            log.debug("Validate")
        }
    }

    let coordinator = TTSEmptyCoordinator()
    let viewModel = TTSThenValidateViewViewModel(coordinator: coordinator)

    return TTSThenValidateView(viewModel: viewModel)
}
