// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class GameplaySelectAllRightAnswersDeprecated: SelectionGameplayProtocol {
    public var choices = CurrentValueSubject<[ChoiceModel], Never>([])
    public var state = CurrentValueSubject<GameplayStateDeprecated, Never>(.idle)

    private var rightAnswersGiven: [ChoiceModel] = []

    public init(choices: [ChoiceModel]) {
        self.choices.send(choices)
        self.state.send(.playing)
    }

    public func process(choice: ChoiceModel) {
        if choice.isRightAnswer {
            if let index = choices.value.firstIndex(where: { $0.id == choice.id && $0.status != .rightAnswer }
            ) {
                self.choices.value[index].status = .rightAnswer

                rightAnswersGiven.append(self.choices.value[index])
            }
        } else {
            if let index = choices.value.firstIndex(where: { $0.id == choice.id }) {
                self.choices.value[index].status = .wrongAnswer

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.choices.value[index].status = .notSelected
                }
            }
        }

        let rightAnswersGivenID = rightAnswersGiven.sorted().map({ $0.id })
        let rightAnswersID =
            choices.value
            .filter { choice in
                choice.isRightAnswer
            }
            .sorted().map({ $0.id })

        if rightAnswersGivenID == rightAnswersID {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                for choice in self.choices.value.filter({ $0.status == .rightAnswer }) {
                    guard let index = self.choices.value.firstIndex(where: { $0.id == choice.id }) else { return }
                    self.choices.value[index].status = .notSelected
                }
                self.rightAnswersGiven.removeAll()
                self.state.send(.finished)
            }

            // TODO(@ladislas): Run reinforcers and lottie animation
        }
    }
}
