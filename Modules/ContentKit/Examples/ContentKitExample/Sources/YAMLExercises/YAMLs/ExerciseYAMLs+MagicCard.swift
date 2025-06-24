// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

extension ExerciseYAMLs {
    // MARK: Public

    static let kMagicCardNumberRecognitionYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Apporte la bonne carte sur le front de Leka"
          - locale: en_US
            value: "Bring the correct card on Leka's forehead"
        interface: magicCards
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: image
            value: magicCardNumbers5Five
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: number_1
            - value: number_2
            - value: number_3
            - value: number_4
            - value: number_5
              is_right_answer: true
            - value: number_6
        """

    static let kMagicCardScreenColorRecognitionYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Apporte la bonne carte sur le front de Leka"
          - locale: en_US
            value: "Bring the correct card on Leka's forehead"
        interface: magicCards
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: image
            value: magicCardColorsOrangePaint
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: color_red
            - value: color_yellow
            - value: color_blue
            - value: color_orange
              is_right_answer: true
            - value: color_green
            - value: color_purple
        """

    static let kMagicCardBeltColorRecognitionYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Apporte la bonne carte sur le front de Leka"
          - locale: en_US
            value: "Bring the correct card on Leka's forehead"
        interface: magicCards
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: color
            value: red
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: color_red
              is_right_answer: true
            - value: color_yellow
            - value: color_blue
            - value: color_orange
            - value: color_green
            - value: color_purple
        """

    static let kMagicCardEmotionRecognitionYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Apporte la bonne carte sur le front de Leka"
          - locale: en_US
            value: "Bring the correct card on Leka's forehead"
        interface: magicCards
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: image
            value: robotFaceDisgusted
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: emotion_anger_leka
            - value: emotion_disgust_leka
              is_right_answer: true
            - value: emotion_fear_leka
            - value: emotion_joy_leka
            - value: emotion_sadness_leka
        """

    static let kMagicCardSpotCountingYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Apporte la bonne carte sur le front de Leka"
          - locale: en_US
            value: "Bring the correct card on Leka's forehead"
        interface: magicCards
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: spots
            value: 4
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: number_1
            - value: number_2
            - value: number_3
            - value: number_4
              is_right_answer: true
            - value: number_5
            - value: number_6
        """

    static let kMagicCardFlashCountingYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Apporte la bonne carte sur le front de Leka"
          - locale: en_US
            value: "Bring the correct card on Leka's forehead"
        interface: magicCards
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: flash
            value: 3
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: number_1
            - value: number_2
            - value: number_3
              is_right_answer: true
            - value: number_4
            - value: number_5
            - value: number_6
        """
}
