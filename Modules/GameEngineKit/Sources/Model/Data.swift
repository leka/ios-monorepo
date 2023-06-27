// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public enum DataType {
    case color, image, text
}

public class Data {
    public var choices: [ChoiceViewModel]
    public var rightAnswers: [ChoiceViewModel]
    public var types: [DataType]
    public var answersNumber: Int?

    public init(
        choices: [ChoiceViewModel], rightAnswers: [ChoiceViewModel], types: [DataType],
        answersNumber: Int? = nil
    ) {
        self.choices = choices
        self.rightAnswers = rightAnswers
        self.types = types
        self.answersNumber = answersNumber
    }
}
