// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import RobotKit

extension ExerciseData {
    static let kFindTheRightAnswersMagicCardEmotions: [MagicCardCoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: MagicCard.emotion_disgust_leka, isRightAnswer: true),
        .init(value: MagicCard.emotion_fear_leka),
        .init(value: MagicCard.emotion_joy_leka),
        .init(value: MagicCard.emotion_sadness_leka),
        .init(value: MagicCard.emotion_anger_leka),
    ]

    static let kFindTheRightAnswersMagicCardNumbers: [MagicCardCoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: MagicCard.number_0),
        .init(value: MagicCard.number_1),
        .init(value: MagicCard.number_2),
        .init(value: MagicCard.number_3),
        .init(value: MagicCard.number_4),
        .init(value: MagicCard.number_5, isRightAnswer: true),
        .init(value: MagicCard.number_6),
    ]

    static let kFindTheRightAnswersMagicCardColors: [MagicCardCoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: MagicCard.color_red),
        .init(value: MagicCard.color_blue),
        .init(value: MagicCard.color_yellow),
        .init(value: MagicCard.color_green),
        .init(value: MagicCard.color_orange, isRightAnswer: true),
        .init(value: MagicCard.color_purple),
    ]
}
