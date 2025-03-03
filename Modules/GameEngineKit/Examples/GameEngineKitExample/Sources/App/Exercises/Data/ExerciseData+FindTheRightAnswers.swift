// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit

extension ExerciseData {
    // MARK: Public

    static let kFindTheRightAnswersChoicesDefault: [CoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "Cow"),
        .init(value: "Horse"),
        .init(value: "Duck", isRightAnswer: true),
        .init(value: "Pig"),
        .init(value: "Koala"),
        .init(value: "Duck", isRightAnswer: true),
    ]

    static let kFindTheRightAnswersChoicesImages: [CoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "emotion_picto_angry_leka", type: .image),
        .init(value: "emotion_picto_disgust_leka", type: .image),
        .init(value: "emotion_picto_fear_leka", type: .image),
        .init(value: "emotion_picto_joy_leka", type: .image, isRightAnswer: true),
        .init(value: "emotion_picto_sad_leka", type: .image),
    ]

    static let kFindTheRightAnswersChoicesSFSymbols: [CoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "star", type: .sfsymbol, isRightAnswer: true),
        .init(value: "circle", type: .sfsymbol),
        .init(value: "square", type: .sfsymbol),
        .init(value: "triangle", type: .sfsymbol),
    ]

    static let kFindTheRightAnswersChoicesEmojis: [CoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "🕺", type: .emoji, isRightAnswer: true),
        .init(value: "🚴", type: .emoji),
        .init(value: "🏃‍♂️", type: .emoji),
    ]

    static let kFindTheRightAnswersChoicesColors: [CoordinatorFindTheRightAnswersChoiceModel] = [
        .init(value: "red", type: .color),
        .init(value: "blue", type: .color, isRightAnswer: true),
    ]

    static let kFindTheRightAnswersYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: Touche les emojis qui sont identiques
          - locale: en_US
            value: Tap the emojis that are the same
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: ipad
          value:
            type: speech
            value:
              - locale: fr_FR
                utterance: "mets les bananes ensemble"
              - locale: en_US
                utterance: "put the bananas together"
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: 🍉
              type: emoji
              is_right_answer: true
            - value: 🍌
              type: emoji
            - value: 🍒
              type: emoji
            - value: 🍉
              type: emoji
              is_right_answer: true
            - value: 🥝
              type: emoji
            - value: 🥥
              type: emoji
        """
}
