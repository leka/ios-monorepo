// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public enum GameplayType {
    case selectTheRightAnswer
    case selectAllRightAnswers
    case selectSomeRightAnswers
}

public class StepManager {
    public var stepModel: any StepModelProtocol
    public var gameplay: any GameplayProtocol
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    var cancellables = Set<AnyCancellable>()

    public init(stepModel: any StepModelProtocol, state: GameplayState = .idle) {
        self.stepModel = stepModel
        self.gameplay = StepManager.gameplaySelector(stepModel: stepModel)
        self.gameplay.state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.state.send($0)
            })
            .store(in: &cancellables)
    }

    public static func gameplaySelector(stepModel: any StepModelProtocol) -> any GameplayProtocol {
        switch stepModel.gameplay {
            case .selectTheRightAnswer:
                return GameplaySelectTheRightAnswer(choices: stepModel.choices)
            case .selectAllRightAnswers:
                return GameplaySelectAllRightAnswers(choices: stepModel.choices)
            case .selectSomeRightAnswers:
                return GameplaySelectSomeRightAnswers(
                    choices: stepModel.choices, rightAnswersToFind: stepModel.answersNumber!)
        }
    }
}
