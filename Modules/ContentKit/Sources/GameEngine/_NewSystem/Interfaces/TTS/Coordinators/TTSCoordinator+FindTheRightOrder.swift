// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorFindTheRightOrder

public class TTSCoordinatorFindTheRightOrder: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    public init(choices: [CoordinatorFindTheRightOrderChoiceModel], action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        let options = options ?? NewExerciseOptions()
        self.rawChoices = choices

        self.gameplay = NewGameplayFindTheRightOrder(
            choices: choices.map { .init(id: $0.id) }
        )
        self.uiModel.value.action = action
        self.uiModel.value.choices = choices.map { choice in
            let view = ChoiceView(value: choice.value,
                                  type: choice.type,
                                  size: self.uiModel.value.choiceSize(for: choices.count),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }
        if options.shuffleChoices {
            self.uiModel.value.choices.shuffle()
        }

        self.validationState.value = (options.validation == .manual) ? .disabled : .hidden
    }

    public convenience init(model: CoordinatorFindTheRightOrderModel, action: NewExerciseAction? = nil, options: NewExerciseOptions? = nil) {
        self.init(choices: model.choices, action: action, options: options)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)
    public private(set) var validationState = CurrentValueSubject<ValidationState, Never>(.hidden)

    public var didComplete: PassthroughSubject<ExerciseCompletionData, Never> = .init()

    public func processUserSelection(choiceID: UUID) {
        if let index = self.currentOrderedChoices.firstIndex(of: choiceID) {
            self.currentOrderedChoices.remove(at: index)
            self.updateChoiceState(for: choiceID, to: .idle)
        } else {
            self.currentOrderedChoices.append(choiceID)
            self.updateChoiceState(for: choiceID, to: .selected(order: self.currentOrderedChoicesIndex))
        }

        for (index, id) in self.currentOrderedChoices.enumerated() {
            self.updateChoiceState(for: id, to: .selected(order: index + 1))
        }

        if self.validationState.value != .hidden {
            self.validationState.send(self.currentOrderedChoices.isNotEmpty ? .enabled : .disabled)
        } else {
            if self.currentOrderedChoicesIndex == self.rawChoices.count {
                self.validateUserSelection()
            }
        }
    }

    public func validateUserSelection() {
        self.completionData.numberOfTrials += 1

        _ = self.gameplay.process(choiceIDs: self.currentOrderedChoices)

        if self.gameplay.isCompleted.value {
            for (indice, id) in self.currentOrderedChoices.enumerated() {
                self.updateChoiceState(for: id, to: .correct(order: indice + 1))
            }

            self.validationState.send(.hidden)
            // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                logGEK.debug("Exercise completed")
                self.didComplete.send(self.completionData)
            }
        } else {
            self.currentOrderedChoices.forEach { id in
                self.updateChoiceState(for: id, to: .idle)
            }
        }

        self.currentOrderedChoices.removeAll()
    }

    // MARK: Private

    private var currentOrderedChoices: [UUID] = []
    private let gameplay: NewGameplayFindTheRightOrder
    private let rawChoices: [CoordinatorFindTheRightOrderChoiceModel]

    private var completionData: ExerciseCompletionData = .init()

    private var currentOrderedChoicesIndex: Int {
        self.currentOrderedChoices.count
    }

    private func updateChoiceState(for choiceID: UUID, to state: State) {
        guard let index = self.rawChoices.firstIndex(where: { $0.id == choiceID }),
              let uiModelIndex = self.uiModel.value.choices.firstIndex(where: { $0.id == choiceID }) else { return }

        let view = ChoiceView(value: self.rawChoices[index].value,
                              type: self.rawChoices[index].type,
                              size: self.uiModel.value.choiceSize(for: self.rawChoices.count),
                              state: state)

        if case .correct = state {
            self.uiModel.value.choices[uiModelIndex] = TTSUIChoiceModel(id: choiceID, view: view, disabled: true)
        } else {
            self.uiModel.value.choices[uiModelIndex] = TTSUIChoiceModel(id: choiceID, view: view, disabled: false)
        }
    }
}

extension TTSCoordinatorFindTheRightOrder {
    enum State {
        case idle
        case selected(order: Int)
        case correct(order: Int)
    }

    struct ChoiceView: View {
        // MARK: Lifecycle

        init(value: String, type: ChoiceType, size: CGFloat, state: State) {
            self.value = value
            self.type = type
            self.size = size
            self.state = state
        }

        // MARK: Internal

        var body: some View {
            switch self.state {
                case .correct:
                    TTSChoiceViewDefaultCorrect(value: self.value, type: self.type, size: self.size)
                case let .selected(order):
                    TTSChoiceView(value: self.value, type: self.type, size: self.size)
                        .overlay {
                            Image(systemName: "\(order).circle.fill")
                                .resizable()
                                .frame(width: self.size, height: self.size)
                                .opacity(0.4)
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                        }
                case .idle:
                    TTSChoiceViewDefaultIdle(value: self.value, type: self.type, size: self.size)
            }
        }

        // MARK: Private

        private let value: String
        private let type: ChoiceType
        private let size: CGFloat
        private let state: State
    }
}

#Preview {
    let kDefaultChoices: [CoordinatorFindTheRightOrderChoiceModel] = [
        .init(value: "Choice 3", alreadyOrdered: false),
        .init(value: "Choice 2", alreadyOrdered: false),
        .init(value: "Choice 5", alreadyOrdered: true),
        .init(value: "Choice 1", alreadyOrdered: false),
        .init(value: "Choice 6", alreadyOrdered: false),
        .init(value: "Choice 4", alreadyOrdered: false),
    ]

    let coordinator = TTSCoordinatorFindTheRightOrder(choices: kDefaultChoices)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
