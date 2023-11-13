// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import Foundation

class GameplayAssociation<ChoiceModelType>: StatefulGameplayProtocol
where ChoiceModelType: GameplayChoiceModelProtocol {

    var choices: CurrentValueSubject<[GameplayAssociationChoiceModel], Never> = .init([])
    var rightAnswers: [ChoiceModelType] = []
    var destinations: [ChoiceModelType] = []
    var state: CurrentValueSubject<ExerciseState, Never> = .init(.idle)

    func updateChoice(_ choice: ChoiceModelType, state: GameplayChoiceState) {
        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else {
            return
        }
        choices.value[index].state = state
    }

}

extension GameplayAssociation where ChoiceModelType == GameplayAssociationChoiceModel {

    convenience init(choices: [GameplayAssociationChoiceModel]) {
        self.init()
        self.choices.send(choices)
        self.state.send(.playing)
    }

    func process(_ choice: ChoiceModelType, _ destination: ChoiceModelType) {
        if choice.choice.category == destination.choice.category
            && !rightAnswers.contains(where: { $0.id == destination.id })
        {
            updateChoice(choice, state: .rightAnswer)
            rightAnswers.append(choice)
            if !destinations.contains(where: { $0.id == destination.id }) {
                destinations.append(destination)
            }
            if (rightAnswers.count + destinations.count) == self.choices.value.count {
                state.send(.completed)
            }
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }
    }

}
