// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import Foundation

class GameplayAssociateCategories: StatefulGameplayProtocol, ChoiceProviderGameplayProtocol {
    var choices: CurrentValueSubject<[any GameplayChoiceModelProtocol], Never> = .init([])
    var state: CurrentValueSubject<ExerciseState, Never> = .init(.idle)
    var numberOfTrials = 0
    var allowedTrials = 0
    var startTimestamp: Date?

    func updateChoice(_ choice: any GameplayChoiceModelProtocol, state: GameplayChoiceState) {
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
        guard let choices = self.choices.value as? [GameplayAssociateCategoriesChoiceModel] else {
            fatalError("Choice model incorrect")
        }
        let numberOfRightAnswers = self.getNumberOfRightAnswers(choices: choices)

        return table[numberOfChoices]![numberOfRightAnswers]!
    }
}
