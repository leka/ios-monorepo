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
        if choice.choice.category == destination.choice.category {
            updateChoice(choice, state: .rightAnswer)
            rightAnswers.append(choice)
            rightAnswers.append(destination)
        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        if rightAnswers.count == self.choices.value.count {
            state.send(.completed)
        }
    }

}
