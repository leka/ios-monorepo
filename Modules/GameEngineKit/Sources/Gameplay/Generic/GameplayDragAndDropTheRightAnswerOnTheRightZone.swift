// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class GameplayDragAndDropOneAnswerOnTheRightZone: DragAndDropGameplayProtocol {
    public var choices = CurrentValueSubject<[ChoiceModel], Never>([])
    public var dropZones = CurrentValueSubject<[DragAndDropZoneModel], Never>([])
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    private var rightAnswersGiven: [ChoiceModel] = []

    public init(choices: [ChoiceModel], dropZones: [DragAndDropZoneModel]) {
        self.choices.send(choices)
        self.dropZones.send(dropZones)
        self.state.send(.playing)
    }

    public func process(choice: ChoiceModel, dropZoneName: String) {
        if let dropZoneIndex = dropZones.value.firstIndex(where: { $0.value == dropZoneName }) {
            if let rightDropChoiceindex = dropZones.value[dropZoneIndex].choices
                .firstIndex(where: { $0.id == choice.id })
            {
                self.dropZones.value[dropZoneIndex].choices[rightDropChoiceindex].status = .rightAnswer
                // TODO(@ladislas): Run reinforcers and lottie animation

                // TO DO (@hugo) asyncAwait
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.dropZones.value[dropZoneIndex].choices[rightDropChoiceindex].status = .notSelected
                    self.state.send(.finished)
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
    }
}
