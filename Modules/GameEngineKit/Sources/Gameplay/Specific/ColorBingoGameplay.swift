// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import RobotKit

public class ColorBingoGameplay: SelectionGameplayProtocol {
    public var choices = CurrentValueSubject<[ChoiceModel], Never>([])
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    private let robot = Robot.shared

    public init(choices: [ChoiceModel]) {
        self.choices.send(choices)
        self.state.send(.playing)

        // TODO(@ladislas): Show the right answer color on Leka's belt
        let index = self.choices.value.firstIndex(where: { $0.isRightAnswer })!
        let color: Robot.Color = .init(from: self.choices.value[index].value)
        print("Leka is \(color)")
        robot.shine(.all(in: color))
    }

    public func process(choice: ChoiceModel) {
        if choice.isRightAnswer {
            if let index = choices.value.firstIndex(where: { $0.id == choice.id }) {
                self.choices.value[index].status = .rightAnswer

                // TODO(@ladislas): Run reinforcers and lottie animation
                robot.run(.rainbow)

                // TODO(@HPezz) asyncAwait
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.choices.value[index].status = .notSelected
                    self.state.send(.finished)
                }
            }
        } else {
            if let index = choices.value.firstIndex(where: { $0.id == choice.id }) {
                self.choices.value[index].status = .wrongAnswer

                // TODO(@HPezz) asyncAwait
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.choices.value[index].status = .notSelected
                }
            }
        }
    }
}
