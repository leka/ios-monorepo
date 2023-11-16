// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

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

        if choices.value.allSatisfy({ $0.state == .rightAnswer }) {
            state.send(.completed)
        }
    }

}
