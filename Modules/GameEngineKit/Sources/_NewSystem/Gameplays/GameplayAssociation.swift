// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import Foundation

class GameplayAssociation<ChoiceModelType>: StatefulGameplayProtocol
where ChoiceModelType: GameplayChoiceModelProtocol {

    var choices: CurrentValueSubject<[GameplayAssociationChoiceModel], Never> = .init([])
    var state: CurrentValueSubject<ExerciseState, Never> = .init(.idle)

    func updateChoice(_ choice: ChoiceModelType, state: GameplayChoiceState) {
        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else {
            return
        }
        choices.value[index].state = state
    }

}

extension GameplayAssociation where ChoiceModelType == GameplayAssociationChoiceModel {

    convenience init(choices: [GameplayAssociationChoiceModel], shuffle: Bool = false) {
        self.init()
        self.choices.send(choices)
        self.state.send(.playing)
    }

    func process(_ choice: ChoiceModelType, _ destination: ChoiceModelType) {
        if choice.choice.category == destination.choice.category {
            updateChoice(choice, state: .rightAnswer)
            updateChoice(destination, state: .rightAnswer)

        } else {
            updateChoice(choice, state: .wrongAnswer)
        }

        guard choices.value.allSatisfy({ $0.state == .rightAnswer }) else {
            return
        }
        state.send(.completed)
    }

}
