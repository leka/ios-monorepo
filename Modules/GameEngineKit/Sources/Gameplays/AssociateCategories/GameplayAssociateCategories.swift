// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import Foundation

class GameplayAssociateCategories<ChoiceModelType>: StatefulGameplayProtocol
    where ChoiceModelType: GameplayChoiceModelProtocol
{
    var choices: CurrentValueSubject<[GameplayAssociateCategoriesChoiceModel], Never> = .init([])
    var state: CurrentValueSubject<ExerciseState, Never> = .init(.idle)
    var numberOfTrials = 0
    var allowedTrials = 0
    var startTimestamp: Date?

    func updateChoice(_ choice: ChoiceModelType, state: GameplayChoiceState) {
        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else {
            return
        }
        self.choices.value[index].state = state
    }

    func getNumberOfRightAnswers(choices: [GameplayAssociateCategoriesChoiceModel]) -> Int {
        let numberOfCategories = Set(choices.map(\.choice.category)).count
        let numberOfCategorizableChoices = choices.map { $0.choice.category != .none }.count

        return numberOfCategorizableChoices - numberOfCategories
    }

    func getNumberOfAllowedTrials(from table: GradingLUT) -> Int {
        let numberOfChoices = self.choices.value.count
        let numberOfRightAnswers = self.getNumberOfRightAnswers(choices: self.choices.value)

        return table[numberOfChoices]![numberOfRightAnswers]!
    }
}
