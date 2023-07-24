// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class GameplaySelectTheRightAnswer: GameplayProtocol {
    @Published public var choices: [ChoiceViewModel]
    @Published public var isFinished: Bool = false

    public var choicesPublisher: Published<[ChoiceViewModel]>.Publisher { $choices }
    public var isFinishedPublisher: Published<Bool>.Publisher { $isFinished }

    public init(choices: [ChoiceViewModel]) {
        self.choices = choices
    }

    public func process(choice: ChoiceViewModel) {
        if choice.rightAnswer {
            if let index = choices.firstIndex(where: { $0.id == choice.id }) {
                self.choices[index].status = .playingRightAnimation
                Task {
                    await resetChoicesStatus(index: index)
                }
                self.isFinished = true
            }
        } else {
            if let index = choices.firstIndex(where: { $0.id == choice.id }) {
                self.choices[index].status = .playingWrongAnimation
                Task {
                    await resetChoicesStatus(index: index)
                }
            }
        }
    }

    public func resetChoicesStatus(index: Int) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.choices[index].status = .notSelected
        }
    }
}
