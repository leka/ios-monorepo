// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest

@testable import ContentKit

final class NewGameplayFindTheRightNumber_Tests: XCTestCase {
    // MARK: Internal

    func test_process_whenSelectionMatchesRequestedNumber_completes() {
        let choices = self.makeChoices(numberOfRightAnswers: 4)
        let gameplay = NewGameplayFindTheRightNumber(choices: choices, requestedNumber: 3)

        let results = gameplay.process(choiceIDs: [choices[0].id, choices[1].id, choices[2].id])

        XCTAssertTrue(results.allSatisfy(\.isCorrect))
        XCTAssertTrue(gameplay.isCompleted.value)
    }

    func test_process_whenSelectionHasTooFewRightAnswers_doesNotComplete() {
        let choices = self.makeChoices()
        let gameplay = NewGameplayFindTheRightNumber(choices: choices)

        let results = gameplay.process(choiceIDs: [choices[0].id, choices[1].id])

        XCTAssertTrue(results.allSatisfy(\.isCorrect))
        XCTAssertFalse(gameplay.isCompleted.value)
    }

    func test_process_whenSelectionHasDistractor_doesNotComplete() {
        let choices = self.makeChoices()
        let gameplay = NewGameplayFindTheRightNumber(choices: choices)

        let results = gameplay.process(choiceIDs: [choices[0].id, choices[1].id, choices[3].id])

        XCTAssertEqual(results.map(\.isCorrect), [true, true, false])
        XCTAssertFalse(gameplay.isCompleted.value)
    }

    func test_process_whenSelectionHasTooManyRightAnswers_doesNotComplete() {
        let choices = self.makeChoices(numberOfRightAnswers: 4)
        let gameplay = NewGameplayFindTheRightNumber(choices: choices, requestedNumber: 3)

        let results = gameplay.process(choiceIDs: [choices[0].id, choices[1].id, choices[2].id, choices[3].id])

        XCTAssertEqual(results.map(\.isCorrect), [true, true, true, true])
        XCTAssertFalse(gameplay.isCompleted.value)
    }

    // MARK: Private

    private func makeChoices(numberOfRightAnswers: Int = 3) -> [NewGameplayFindTheRightNumberChoiceModel] {
        (0..<6).map { index in
            .init(id: UUID(), isRightAnswer: index < numberOfRightAnswers)
        }
    }
}
