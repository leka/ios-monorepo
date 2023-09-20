// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class ColorQuestGameplay: GameplayProtocol {
    public var choices = CurrentValueSubject<[ChoiceViewModel], Never>([])
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    public init(choices: [ChoiceViewModel]) {
        self.choices.send(choices)
        self.state.send(.playing)
    }

	public func setup() {
		// TODO(@ladislas): Show the right answer color on Leka's belt
		let index = self.choices.value.firstIndex(where: { $0.rightAnswer })!
		let color = self.choices.value[index].item
		print("Leka is \(color)")
	}

    public func process(choice: ChoiceViewModel) {
        if choice.rightAnswer {
            if let index = choices.value.firstIndex(where: { $0.id == choice.id }) {
                self.choices.value[index].status = .playingRightAnimation

                // TO DO (@hugo) asyncAwait
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.choices.value[index].status = .notSelected
                }
                self.state.send(.finished)
                // TODO(@ladislas): Run reinforcers and lottie animation
            }
        } else {
            if let index = choices.value.firstIndex(where: { $0.id == choice.id }) {
                self.choices.value[index].status = .playingWrongAnimation

                // TO DO (@hugo) asyncAwait
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.choices.value[index].status = .notSelected
                }
            }
        }
    }
}
