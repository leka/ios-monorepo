// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public class StandardGameplayData {
    public var choices: [ChoiceViewModel]
    public var answersNumber: Int?

    public init(
        choices: [ChoiceViewModel],
        answersNumber: Int? = nil
    ) {
        self.choices = choices
        self.answersNumber = answersNumber
    }
}
