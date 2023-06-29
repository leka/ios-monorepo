// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class GameplaySelectTheRightAnswer: GameplayProtocol {
    public let name = "Select The Right Answer"
    public let rightAnswers: [ChoiceViewModel]
    @Published public var choices: [ChoiceViewModel]
    @Published public var isFinished: Bool = false

    public var choicesPublisher: Published<[ChoiceViewModel]>.Publisher { $choices }
    public var isFinishedPublisher: Published<Bool>.Publisher { $isFinished }

    public init(choices: [ChoiceViewModel], rightAnswers: [ChoiceViewModel]) {
        self.choices = choices
        self.rightAnswers = rightAnswers
    }

    public func process(choice: ChoiceViewModel) {
        if choice.item == rightAnswers[0].item {
            if let index = choices.firstIndex(where: { $0.id == choice.id }) {
                self.choices[index].status = .playingRightAnimation

                // TO DO (@hugo) asyncAwait
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.choices[index].status = .notSelected
                }
                self.isFinished = true
            }
        } else {
            if let index = choices.firstIndex(where: { $0.id == choice.id }) {
                self.choices[index].status = .playingWrongAnimation

				// TO DO (@hugo) asyncAwait
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.choices[index].status = .notSelected
                }
            }
        }
    }
}
