// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSCoordinatorFindTheRightOrder

class TTSCoordinatorFindTheRightOrder: TTSGameplayCoordinatorProtocol {
    // MARK: Lifecycle

    init(gameplay: GameplayFindTheRightOrder) {
        self.gameplay = gameplay

        self.uiChoices.value = self.gameplay.choices.value.map { choice in
            TTSChoiceModel(id: choice.id, value: choice.value, state: Self.stateConverter(from: choice.state))
        }

        self.gameplay.choices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] choices in
                guard let self else { return }

                self.uiChoices.value = choices.map { choice in
                    TTSChoiceModel(id: choice.id, value: choice.value, state: Self.stateConverter(from: choice.state))
                }
            }
            .store(in: &self.cancellables)
    }

    // MARK: Public

    public static let kDefaultChoices: [FindTheRightOrderChoice] = [
        FindTheRightOrderChoice(value: "1rst choice"),
        FindTheRightOrderChoice(value: "2nd choice"),
        FindTheRightOrderChoice(value: "3rd choice"),
        FindTheRightOrderChoice(value: "4th choice"),
        FindTheRightOrderChoice(value: "5th choice"),
        FindTheRightOrderChoice(value: "6th choice"),
    ]

    // MARK: Internal

    private(set) var uiChoices = CurrentValueSubject<[TTSChoiceModel], Never>([])

    func processUserSelection(choice: TTSChoiceModel) {
        log.debug("[CO] \(choice.id) - \(choice.value.replacingOccurrences(of: "\n", with: " ")) - \(choice.state)")
        guard var gameplayChoice = self.gameplay.choices.value.first(where: { $0.id == choice.id }) else { return }

        self.selectedOrder[self.currentOrderIndex] = gameplayChoice
        gameplayChoice.state = .selected(order: self.currentOrderIndex + 1)
        self.currentOrderIndex += 1

        self.gameplay.updateChoice(choice: gameplayChoice)

        if self.selectedOrder.count == self.gameplay.choices.value.count {
            self.currentOrderIndex = 0
            let correctSelectedOrder = self.gameplay.evaluateOrder(selectedOrder: self.selectedOrder)
            if correctSelectedOrder.count == self.gameplay.choices.value.count {
                for (index, choice) in self.gameplay.rawChoices.enumerated() {
                    var choice = choice
                    choice.state = .correct(order: index + 1)
                    self.gameplay.updateChoice(choice: choice)
                }
            } else {
                self.selectedOrder.removeAll()
                for choice in self.gameplay.choices.value {
                    var choice = choice
                    choice.state = .idle
                    self.gameplay.updateChoice(choice: choice)
                }
            }
        }
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private var currentOrderIndex: Int = 0
    private let gameplay: GameplayFindTheRightOrder
    private var selectedOrder: [Int: FindTheRightOrderChoice] = [:]

    private static func stateConverter(from state: FindTheRightOrderChoiceState) -> TTSChoiceState {
        switch state {
            case .idle:
                .idle
            case let .selected(order):
                .selected(order: order)
            case let .correct(order):
                .correct(order: order)
            case .wrong:
                .wrong
        }
    }
}

#Preview {
    let gameplay = GameplayFindTheRightOrder(choices: TTSCoordinatorFindTheRightOrder.kDefaultChoices)
    let coordinator = TTSCoordinatorFindTheRightOrder(gameplay: gameplay)
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}
