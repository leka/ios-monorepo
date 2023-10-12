// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class GameplaySelectTheRightAnswer: ChoiceGameplayProtocol {
    public var choices = CurrentValueSubject<[ChoiceModel], Never>([])
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    public init(choices: [ChoiceModel]) {
        self.choices.send(choices)
        self.state.send(.playing)
    }

    public func process(choice: ChoiceModel) {
        if choice.rightAnswer {
            if let index = choices.value.firstIndex(where: { $0.id == choice.id }) {
                self.choices.value[index].status = .rightAnswer

                // TO DO (@hugo) asyncAwait
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.choices.value[index].status = .notSelected
                    self.state.send(.finished)
                }

                // TODO(@ladislas): Run reinforcers and lottie animation
            }
        } else {
            if let index = choices.value.firstIndex(where: { $0.id == choice.id }) {
                self.choices.value[index].status = .wrongAnswer

                // TO DO (@hugo) asyncAwait
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.choices.value[index].status = .notSelected
                }
            }
        }
    }
}
