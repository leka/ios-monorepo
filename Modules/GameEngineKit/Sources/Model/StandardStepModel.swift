// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public class StandardStepModel {
    public var choices: [ChoiceViewModel]
	public var gameplay : GameplayType
    public var answersNumber: Int?

    public init(
        choices: [ChoiceViewModel],
		gameplay : GameplayType,
        answersNumber: Int? = nil
    ) {
        self.choices = choices
		self.gameplay = gameplay
        self.answersNumber = answersNumber
    }
}
