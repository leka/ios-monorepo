// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

// MARK: - FindTheRightOrderChoiceState

enum FindTheRightOrderChoiceState {
    case idle
    case selected(order: Int)
    case correct(order: Int)
    case wrong
}

// MARK: - FindTheRightOrderChoice

struct FindTheRightOrderChoice: Identifiable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, value: String) {
        self.id = id
        self.value = value
    }

    // MARK: Internal

    let id: String
    let value: String
    var state: FindTheRightOrderChoiceState = .idle
}

// MARK: - GameplayFindTheRightOrder

class GameplayFindTheRightOrder: GameplayProtocol {
    // MARK: Lifecycle

    init(choices: [FindTheRightOrderChoice]) {
        self.rawChoices = choices
        self.choices.value = choices.shuffled()
    }

    // MARK: Public

    public private(set) var choices = CurrentValueSubject<[FindTheRightOrderChoice], Never>([])
    public let rawChoices: [FindTheRightOrderChoice]
    public var isCompleted = CurrentValueSubject<Bool, Never>(false)

    // MARK: Internal

    typealias ChoiceType = FindTheRightOrderChoice

    func process(choice _: FindTheRightOrderChoice) {
        // Nothing to do
    }

    func evaluateOrder(selectedOrder: [Int: FindTheRightOrderChoice]) -> [Int: FindTheRightOrderChoice] {
        var correctSelectedOrder = selectedOrder
        self.isCorrectOrder = true

        for (index, answer) in self.rawChoices.enumerated() {
            var choice = answer
            if selectedOrder[index]?.id == choice.id {
                choice.state = .correct(order: index + 1)
            } else {
                choice.state = .idle
                self.isCorrectOrder = false
                correctSelectedOrder[index] = nil
            }
        }
        if self.isCorrectOrder {
            log.debug("Exercise completed")
            self.isCompleted.send(true)
        }

        return correctSelectedOrder
    }

    func updateChoice(choice: FindTheRightOrderChoice) {
        guard let index = choices.value.firstIndex(where: { $0.id == choice.id }) else { return }
        self.choices.value[index] = choice
    }

    // MARK: Private

    private var isCorrectOrder = false
}
