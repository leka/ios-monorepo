// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import Foundation

class GameplayAssociateCategories<ChoiceModelType>: StatefulGameplayProtocol
    where ChoiceModelType: GameplayChoiceModelProtocol {
    var choices: CurrentValueSubject<[GameplayAssociateCategoriesChoiceModel], Never> = .init([])
    var state: CurrentValueSubject<ExerciseState, Never> = .init(.idle)

    func updateChoice(_ choice: ChoiceModelType, state: GameplayChoiceState) {
        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else {
            return
        }
        choices.value[index].state = state
    }
}
