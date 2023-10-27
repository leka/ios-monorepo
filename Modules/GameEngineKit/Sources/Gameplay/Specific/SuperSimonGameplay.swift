// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class SuperSimonGameplay: SelectionGameplayProtocol {
    public var choices = CurrentValueSubject<[ChoiceModel], Never>([])
    public var state = CurrentValueSubject<GameplayStateDeprecated, Never>(.idle)

    private var rightAnswersGiven: [ChoiceModel] = []
    private var answerIndexOrder: [Int]

    public init(choices: [ChoiceModel], answerIndexOrder: [Int]) {
        self.choices.send(choices)
        self.state.send(.playing)
        self.answerIndexOrder = answerIndexOrder

        // TODO(@ladislas): Show the right color and song sequence on Leka's belt
        for index in 0..<answerIndexOrder.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 * Double(index)) {
                let choiceIndex = self.answerIndexOrder[index]
                let color = self.choices.value[choiceIndex].value
                print("Leka is \(color)")
            }
        }
    }

    public func process(choice: ChoiceModel) {
        if rightAnswersGiven.count == answerIndexOrder.count {
            return
        }
        if let index = choices.value.firstIndex(where: { $0.id == choice.id && $0.status != .rightAnswer }
        ) {
            if index == answerIndexOrder[rightAnswersGiven.count] {
                self.choices.value[index].status = .rightAnswer

                rightAnswersGiven.append(self.choices.value[index])
            } else {
                self.choices.value[index].status = .wrongAnswer

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.choices.value[index].status = .notSelected
                }
            }
        }

        if rightAnswersGiven.count == answerIndexOrder.count {
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
