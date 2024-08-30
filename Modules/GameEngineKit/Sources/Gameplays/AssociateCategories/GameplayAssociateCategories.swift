// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import Foundation

class GameplayAssociateCategories<ChoiceModelType>: StatefulGameplayProtocol
    where ChoiceModelType: GameplayChoiceModelProtocol
{
    var choices: CurrentValueSubject<[ChoiceModelType], Never> = .init([])
    var state: CurrentValueSubject<ExerciseState, Never> = .init(.idle)
    var isTappable: CurrentValueSubject<Bool, Never> = .init(true)
    var selectedChoices: [ChoiceModelType] = []
    var rightAnswers: [ChoiceModelType] = []
    var numberOfTrials = 0
    var allowedTrials = 0

    func updateChoice(_ choice: ChoiceModelType, state: GameplayChoiceState) {
        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else {
            return
        }
        self.choices.value[index].state = state
    }

    func getNumberOfRightAnswers(choices: [GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate]) -> Int {
        let numberOfCategories = Set(choices.map(\.choice.category)).count
        let numberOfCategorizableChoices = choices.map { $0.choice.category != .none }.count

        return numberOfCategorizableChoices - numberOfCategories
    }

    func getNumberOfAllowedTrials(from table: GradingLUT) -> Int {
        let numberOfChoices = self.choices.value.count
        if let associateChoices = self.choices.value as? [GameplayAssociateCategoriesChoiceModelDragAndDropToAssociate] {
            let numberOfRightAnswers = self.getNumberOfRightAnswers(choices: associateChoices)
            return table[numberOfChoices]![numberOfRightAnswers]!
        } else if let memoryChoices = self.choices.value as? [GameplayMemoryChoiceModel] {
            let numberOfCategories = Set(memoryChoices.map(\.choice.category)).count
            return table[numberOfChoices]![numberOfCategories]!
        } else {
            fatalError("Unknown choice type")
        }
    }
}
