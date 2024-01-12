// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import Foundation

class GameplayFindTheRightAnswers<ChoiceModelType>: StatefulGameplayProtocol
    where ChoiceModelType: GameplayChoiceModelProtocol
{
    var choices: CurrentValueSubject<[ChoiceModelType], Never> = .init([])
    var rightAnswers: [ChoiceModelType] = []
    var state: CurrentValueSubject<ExerciseState, Never> = .init(.idle)
    var numberOfTrials: Int = 0
    var allowedTrials: Int = 0

    func updateChoice(_ choice: ChoiceModelType, state: GameplayChoiceState) {
        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else {
            return
        }
        self.choices.value[index].state = state
    }

    func getNumberOfAllowedTrials(from table: GradingLUT) -> Int {
        let numberOfChoices = self.choices.value.count
        let numberOfRightAnswers = self.rightAnswers.count

        return table[numberOfChoices]![numberOfRightAnswers]!
    }
}
