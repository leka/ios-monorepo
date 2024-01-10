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
    var numberOfTrials: Int = 0
    var allowedTrials: Int = 0

    func updateChoice(_ choice: ChoiceModelType, state: GameplayChoiceState) {
        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else {
            return
        }
        self.choices.value[index].state = state
    }
}
