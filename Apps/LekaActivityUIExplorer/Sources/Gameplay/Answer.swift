// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameplayKit
import SwiftUI

enum AnswerType: Int {
    case wrong = 0
    case right
}

class Answer {
    var answerId: Int
    var answerType: AnswerType
    var color: Color?
    var image: Image?

    static var allAnswers: [Answer] = [Answer(.wrong), Answer(.right)]

    init(_ answerType: AnswerType, color: Color? = nil, image: Image? = nil) {
        self.answerId = answerType.rawValue
        self.answerType = answerType
        self.color = color
        self.image = image
    }

    static func getById(id: AnswerType) -> Answer {
        return id == .wrong ? Answer.allAnswers[0] : Answer.allAnswers[1]
    }
}
