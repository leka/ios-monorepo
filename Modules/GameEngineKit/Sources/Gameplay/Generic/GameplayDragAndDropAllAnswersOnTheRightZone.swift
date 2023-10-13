// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class GameplayDragAndDropAllAnswersOnTheRightZone: DragAndDropGameplayProtocol {
    
    public var choices = CurrentValueSubject<[DragAndDropChoiceModel], Never>([])
    private let dropZones: [DragAndDropZoneModel]
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    private var rightAnswersGiven: [DragAndDropChoiceModel] = []

    public init(choices: [DragAndDropChoiceModel], dropZones: [DragAndDropZoneModel]) {
        self.choices.send(choices)
        self.dropZones = dropZones
        self.state.send(.playing)
    }

    public func process(choice: DragAndDropChoiceModel, dropZoneName: String) {
        if dropZones[choice.dropZone.rawValue].value == dropZoneName {
            // Version enum .none, .first, .second
        }
        if choice.dropZone == dropZoneName {
            // Version enum .none, .first, .second avec name updated directement dans le model
        }
        if let dropZoneIndex = dropZones.value.firstIndex(where: { $0.value == dropZoneName }) {
            if let rightDropChoiceindex = dropZones.value[dropZoneIndex].choices
                .firstIndex(where: { $0.id == choice.id })
            {
                self.dropZones.value[dropZoneIndex].choices[rightDropChoiceindex].status = .rightAnswer

                if let index = choices.value.firstIndex(where: { $0.id == choice.id }) {
                    rightAnswersGiven.append(self.choices.value[index])
                }

                // TO DO (@hugo) asyncAwait
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.dropZones.value[dropZoneIndex].choices[rightDropChoiceindex].status = .notSelected
                }
            } else {
                for dropZone in dropZones.value {
                    if let wrongDropChoiceindex = dropZone.choices.firstIndex(where: { $0.id == choice.id }) {
                        self.dropZones.value[dropZoneIndex].choices[wrongDropChoiceindex].status =
                            .wrongAnswer

                        // TO DO (@hugo) asyncAwait
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            self.dropZones.value[dropZoneIndex].choices[wrongDropChoiceindex].status = .notSelected
                        }
                    }
                }
            }
        }

        let rightAnswersGivenID = rightAnswersGiven.sorted().map({ $0.id })
        let rightAnswersID =
            choices.value
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
