// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public enum Gameplay {
    case selectTheRightAnswer
    case selectAllRightAnswers
    case selectSomeRightAnswers
}

public class GameEngine {
    public var data: Data
    public var gameplay: any GameplayProtocol
    public var viewModel: GenericViewModel

    public init(
        data: Data, gameplay: Gameplay
    ) {
        self.data = data
        self.gameplay = GameEngine.gameplaySelector(gameplay: gameplay, data: data)
        self.viewModel = GenericViewModel(gameplay: self.gameplay)
    }

    static func gameplaySelector(gameplay: Gameplay, data: Data) -> any GameplayProtocol {
        switch gameplay {
            case .selectTheRightAnswer:
                return SelectTheRightAnswer(choices: data.choices, rightAnswers: data.rightAnswers)
            case .selectAllRightAnswers:
                return SelectAllRightAnswers(choices: data.choices, rightAnswers: data.rightAnswers)
            case .selectSomeRightAnswers:
                return SelectSomeRightAnswers(
                    choices: data.choices, rightAnswers: data.rightAnswers, rightAnswersToFind: data.answersNumber!)
        }
    }

}
