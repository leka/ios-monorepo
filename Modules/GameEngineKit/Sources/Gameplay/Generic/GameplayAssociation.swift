// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class GameplayAssociation: GameplayProtocol {
    public var choices = CurrentValueSubject<[AssociationChoiceModel], Never>([])
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    private var rightAnswersGiven: [AssociationChoiceModel] = []

    public init(choices: [AssociationChoiceModel]) {
        self.choices.send(choices)
        self.state.send(.playing)
    }

    public func process(choice: AssociationChoiceModel) {
        //        if choice.rightAnswer {
        if let index = choices.value.firstIndex(where: { $0.id == choice.id && $0.status != .playingRightAnimation }
        ) {
            self.choices.value[index].status = .playingRightAnimation
            print(rightAnswersGiven.count)
            rightAnswersGiven.append(self.choices.value[index])
        }
        //        } else {
        //            if let index = choices.value.firstIndex(where: { $0.id == choice.id }) {
        //                self.choices.value[index].status = .playingWrongAnimation
        //
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
        //                    self.choices.value[index].status = .notSelected
        //                }
        //            }
        //        }

        let rightAnswersGivenID = rightAnswersGiven.sorted().map({ $0.id })
        let rightAnswersID = choices.value.sorted().map({ $0.id })

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
