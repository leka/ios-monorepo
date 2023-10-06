// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class GameplaySelectAllRightAnswers: GameplayProtocol {
    public var choices = CurrentValueSubject<[ChoiceViewModel], Never>([])
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    private var rightAnswersGiven: [ChoiceViewModel] = []

    public init(choices: [ChoiceViewModel]) {
        self.choices.send(choices)
        self.state.send(.playing)
    }

    public func process(choice: ChoiceViewModel) {
        if choice.rightAnswer {
            if let index = choices.value.firstIndex(where: { $0.id == choice.id && $0.status != .playingRightAnimation }
            ) {
                self.choices.value[index].status = .playingRightAnimation

                rightAnswersGiven.append(self.choices.value[index])
            }
        } else {
            if let index = choices.value.firstIndex(where: { $0.id == choice.id }) {
                self.choices.value[index].status = .playingWrongAnimation

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.choices.value[index].status = .notSelected
                }
            }
        }

        let rightAnswersGivenID = rightAnswersGiven.sorted().map({ $0.id })
        let rightAnswersID =
            choices.value
            .filter { choice in
                choice.rightAnswer
            }
            .sorted().map({ $0.id })

        if rightAnswersGivenID == rightAnswersID {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                for choice in self.choices.value.filter({ $0.status == .playingRightAnimation }) {
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
