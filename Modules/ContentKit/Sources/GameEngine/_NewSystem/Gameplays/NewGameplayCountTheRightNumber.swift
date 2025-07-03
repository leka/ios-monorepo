// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import RobotKit

// MARK: - NewGameplayCountTheRightNumberChoiceModel

public struct NewGameplayCountTheRightNumberChoiceModel: Identifiable {
    // MARK: Lifecycle

    public init(expected: Int, choiceIDs: [UUID], selected: Int = 0) {
        self.expected = expected
        self.selected = selected
        self.choiceIDs = choiceIDs
    }

    // MARK: Public

    public let id: UUID = .init()

    // MARK: Internal

    let expected: Int
    var selected: Int
    let choiceIDs: [UUID]
}

// MARK: - NewGameplayCountTheRightNumber

public class NewGameplayCountTheRightNumber: GameplayProtocol {
    // MARK: Lifecycle

    public init(groups: [NewGameplayCountTheRightNumberChoiceModel]) {
        self.groups = groups
    }

    // MARK: Public

    public var groups: [NewGameplayCountTheRightNumberChoiceModel]
    public var isCompleted = CurrentValueSubject<Bool, Never>(false)

    public func process(choiceIDs: [UUID]) -> [(id: UUID, isExpected: Bool)] {
        let results: [(UUID, Bool)] = choiceIDs.compactMap { [weak self] id in
            guard let self, let modelIndex = self.groups.firstIndex(where: { $0.choiceIDs.contains(where: { $0 == id }) }) else { return nil }

            self.groups[modelIndex].selected += 1
            let isExpected: Bool = self.groups[modelIndex].expected > 0 && self.groups[modelIndex].selected <= self.groups[modelIndex].expected
            return (id, isExpected)
        }

        if self.groups.map({ $0.expected == $0.selected }).allSatisfy({ $0 }) {
            self.isCompleted.send(true)
        } else {
            self.groups.indices.forEach {
                if self.groups[$0].selected > self.groups[$0].expected {
                    self.groups[$0].selected = self.groups[$0].expected
                }
            }
        }

        return results
    }

    public func reset() {
        self.groups.indices.forEach { self.groups[$0].selected = 0 }
        self.isCompleted.send(false)
    }

    // MARK: Internal

    typealias ChoiceType = NewGameplayCountTheRightNumberChoiceModel
}
