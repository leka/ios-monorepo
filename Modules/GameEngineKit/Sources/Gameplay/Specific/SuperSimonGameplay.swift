// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class SuperSimonGameplay: GameplayProtocol {
    public var choices = CurrentValueSubject<[ChoiceViewModel], Never>([])
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    private var rightAnswersGiven: [ChoiceViewModel] = []
    private var answerIndexOrder: [Int]

    public init(choices: [ChoiceViewModel], answerIndexOrder: [Int]) {
        self.choices.send(choices)
        self.state.send(.playing)
        self.answerIndexOrder = answerIndexOrder

        // TODO(@ladislas): Show the right color and song sequence on Leka's belt
        for index in 0..<answerIndexOrder.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 * Double(index)) {
                let choiceIndex = self.answerIndexOrder[index]
                let color = self.choices.value[choiceIndex].item
                print("Leka is \(color)")
            }
        }
    }

    public func process(choice: ChoiceViewModel) {
        if rightAnswersGiven.count == answerIndexOrder.count {
            return
        }
        if let index = choices.value.firstIndex(where: { $0.id == choice.id && $0.status != .playingRightAnimation }
        ) {
            if index == answerIndexOrder[rightAnswersGiven.count] {
                self.choices.value[index].status = .playingRightAnimation

                rightAnswersGiven.append(self.choices.value[index])
            } else {
                self.choices.value[index].status = .playingWrongAnimation

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.choices.value[index].status = .notSelected
                }
            }
        }

        if rightAnswersGiven.count == answerIndexOrder.count {
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
