// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import ContentKit
import Foundation

// MARK: - GameplayChooseAnyAnswerChoiceModel

struct GameplayChooseAnyAnswerChoiceModel: GameplayChoiceModelProtocol {
    // MARK: Internal

    typealias ChoiceType = DragAndDropAnyAnswer.Choice

    let id: String = UUID().uuidString
    let choice: ChoiceType

    var statePublisher: AnyPublisher<GameplayChoiceState, Never> {
        self.stateSubject.eraseToAnyPublisher()
    }

    var state: GameplayChoiceState {
        get { self.stateSubject.value }
        set { self.stateSubject.send(newValue) }
    }

    var interactivityPublisher: AnyPublisher<Interactivity, Never> {
        self.interactivitySubject.eraseToAnyPublisher()
    }

    var interactivity: Interactivity {
        get { self.interactivitySubject.value }
        set { self.interactivitySubject.send(newValue) }
    }

    // MARK: Private

//    var state: GameplayChoiceState = .idle
//    var interactivity: Interactivity = .editable
    private let stateSubject = CurrentValueSubject<GameplayChoiceState, Never>(.idle)
    private let interactivitySubject = CurrentValueSubject<Interactivity, Never>(.editable)
}

// MARK: Equatable

extension GameplayChooseAnyAnswerChoiceModel: Equatable {
    static func == (lhs: GameplayChooseAnyAnswerChoiceModel, rhs: GameplayChooseAnyAnswerChoiceModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension GameplayChooseAnyAnswer where ChoiceModelType == GameplayChooseAnyAnswerChoiceModel {
    convenience init(choices: [GameplayChooseAnyAnswerChoiceModel], allowedTrials: Int? = nil) {
        self.init()
        self.rightAnswers = choices
        self.choices.send(choices)
        self.state.send(.playing(type: .unstructured))

        if let allowedTrials {
            self.allowedTrials = allowedTrials
        } else {
            self.allowedTrials = getNumberOfAllowedTrials(from: kGradingLUTAnyAnswer)
        }
    }

    func process(_ choice: ChoiceModelType, _: DragAndDropAnyAnswer.DropZone) {
        numberOfTrials += 1
        updateChoice(choice, state: .selected, interactivity: .editable)
    }
}
