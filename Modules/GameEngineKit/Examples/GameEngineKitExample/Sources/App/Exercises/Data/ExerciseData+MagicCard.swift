// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import RobotKit

extension ExerciseData {
    static let kFindTheRightAnswersMagicCardEmotions: [CoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "emotion_disgust_leka", isRightAnswer: true),
        .init(value: "emotion_fear_leka"),
        .init(value: "emotion_joy_leka"),
        .init(value: "emotion_sadness_leka"),
        .init(value: "emotion_anger_leka"),
    ]

    static let kFindTheRightAnswersMagicCardNumbers: [CoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "number_0"),
        .init(value: "number_1"),
        .init(value: "number_2"),
        .init(value: "number_3"),
        .init(value: "number_4"),
        .init(value: "number_5", isRightAnswer: true),
        .init(value: "number_6"),
    ]

    static let kFindTheRightAnswersMagicCardColors: [CoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "color_red"),
        .init(value: "color_blue"),
        .init(value: "color_yellow"),
        .init(value: "color_green"),
        .init(value: "color_orange", isRightAnswer: true),
        .init(value: "color_purple"),
    ]
}
