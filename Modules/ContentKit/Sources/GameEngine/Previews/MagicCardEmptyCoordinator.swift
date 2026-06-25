// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import RobotKit

#if DEBUG

    class MagicCardEmptyCoordinator: MagicCardGameplayCoordinatorProtocol {
        // MARK: Lifecycle

        init(choices: [MagicCardUIChoiceModel] = kDefaultChoices) {
            self.uiModel = CurrentValueSubject<MagicCardUIModel, Never>(MagicCardUIModel(action: nil, choices: choices))
        }

        // MARK: Public

        public static let kDefaultChoices: [MagicCardUIChoiceModel] = [
            .init(view: MagicCardCoordinatorFindTheRightAnswers.ChoiceView(card: MagicCard(name: "number_1"), size: 240, state: .idle)),
            .init(view: MagicCardCoordinatorFindTheRightAnswers.ChoiceView(card: MagicCard(name: "number_2"), size: 240, state: .idle)),
            .init(view: MagicCardCoordinatorFindTheRightAnswers.ChoiceView(card: MagicCard(name: "number_3"), size: 240, state: .correct)),
            .init(view: MagicCardCoordinatorFindTheRightAnswers.ChoiceView(card: MagicCard(name: "number_4"), size: 240, state: .wrong)),
            .init(view: MagicCardCoordinatorFindTheRightAnswers.ChoiceView(card: MagicCard(name: "number_5"), size: 240, state: .idle)),
            .init(view: MagicCardCoordinatorFindTheRightAnswers.ChoiceView(card: MagicCard(name: "number_6"), size: 240, state: .idle)),
            .init(view: MagicCardCoordinatorFindTheRightAnswers.ChoiceView(card: MagicCard(name: "number_7"), size: 240, state: .idle)),
            .init(view: MagicCardCoordinatorFindTheRightAnswers.ChoiceView(card: MagicCard(name: "number_8"), size: 240, state: .idle)),
        ]

        // MARK: Internal

        var uiModel = CurrentValueSubject<MagicCardUIModel, Never>(.zero)

        func enableMagicCardDetection() {
            logGEK.debug("Card detection enabled")
        }

        func processUserSelection(cardID: UUID) {
            logGEK.debug("\(cardID.uuidString) selected")
        }
    }

#endif
