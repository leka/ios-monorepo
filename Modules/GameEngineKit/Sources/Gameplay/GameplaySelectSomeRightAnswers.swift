// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class GameplaySelectSomeRightAnswers: GameplayProtocol {
    @Published public var choices: [ChoiceViewModel]
    @Published public var state: GameplayState = .idle

    private var rightAnswersGiven: [ChoiceViewModel] = []

    public var rightAnswersToFind: Int

    public var choicesPublisher: Published<[ChoiceViewModel]>.Publisher { $choices }
    public var statePublisher: Published<GameplayState>.Publisher { $state }

    public init(choices: [ChoiceViewModel], rightAnswersToFind: Int) {
        self.choices = choices
        self.rightAnswersToFind = rightAnswersToFind
        self.state = .playing
    }

    public func process(choice: ChoiceViewModel) {
        if choice.rightAnswer {
            if let index = choices.firstIndex(where: { $0.id == choice.id && $0.status != .playingRightAnimation }) {
                self.choices[index].status = .playingRightAnimation

                rightAnswersGiven.append(self.choices[index])
            }
        } else {
            if let index = choices.firstIndex(where: { $0.id == choice.id }) {
                self.choices[index].status = .playingWrongAnimation
                Task {
                    await resetChoicesStatus(index: index)
                }
            }
        }

        if rightAnswersToFind == rightAnswersGiven.count {
            let rightAnswersGivenID = rightAnswersGiven.sorted().map({ $0.id })
            let rightAnswersID =
                choices.filter { choice in
                    choice.rightAnswer
                }
                .sorted().map({ $0.id })

            if rightAnswersGivenID.allSatisfy({ rightAnswersID.contains($0) }) {
                Task {
                    await resetAllRightChoicesStatus()
                }
                rightAnswersGiven.removeAll()
                self.state = .finished
                // Run reinforcers and lottie animation
            }
        }
    }

    public func resetChoicesStatus(index: Int) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.choices[index].status = .notSelected
        }
    }

    public func resetAllRightChoicesStatus() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            for choice in self.choices.filter({ $0.status == .playingRightAnimation }) {
                guard let index = self.choices.firstIndex(where: { $0.id == choice.id }) else { return }
                self.choices[index].status = .notSelected
            }
        }
    }
}
