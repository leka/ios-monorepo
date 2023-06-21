// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public class Data {
    public var choices: [ChoiceViewModel]
    public var rightAnswers: [ChoiceViewModel]
    public var answersNumber: Int?
    public var colors: [Color]?
    public var images: [Image]?
    public var texts: [String]?

    public init(
        choices: [ChoiceViewModel], rightAnswers: [ChoiceViewModel], answersNumber: Int? = nil, colors: [Color]? = nil,
        images: [Image]? = nil,
        texts: [String]? = nil
    ) {
        self.choices = choices
        self.rightAnswers = rightAnswers
        self.answersNumber = answersNumber
        self.colors = colors
        self.images = images
        self.texts = texts
    }
}
