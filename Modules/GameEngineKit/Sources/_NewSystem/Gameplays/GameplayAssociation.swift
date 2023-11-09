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

}
