// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit

extension ExerciseYAMLs {
    // MARK: Public

    static let kTTSFindTheRightAnswersYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche l'image qui exprime la joie"
          - locale: en_US
            value: "Tap the image that expresses joy"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: emotion_picto_angry_leka
              type: image
            - value: emotion_picto_disgust_leka
              type: image
            - value: emotion_picto_fear_leka
              type: image
            - value: emotion_picto_joy_leka
              type: image
              is_right_answer: true
            - value: emotion_picto_sad_leka
              type: image
        """

    static let kTTSFindTheRightAnswersThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche l'image qui exprime la joie"
          - locale: en_US
            value: "Tap the image that expresses joy"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: emotion_picto_angry_leka
              type: image
            - value: emotion_picto_disgust_leka
              type: image
            - value: emotion_picto_fear_leka
              type: image
            - value: emotion_picto_joy_leka
              type: image
              is_right_answer: true
            - value: emotion_picto_sad_leka
              type: image
        """

    static let kObserveImageThenTTSFindTheRightAnswersYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche le sport présenté sur l'image"
          - locale: en_US
            value: "Tap the sport presented on the image"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: ipad
          value:
            type: image
            value: sport_dance_player_man
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: 🕺
              type: emoji
            - value: 🚴
              type: emoji
            - value: 🏃‍♂️
              type: emoji
              is_right_answer: true
        """

    static let kObserveSFSymbolThenTTSFindTheRightAnswersYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche la bonne forme"
          - locale: en_US
            value: "Tap the correct shape"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: ipad
          value:
            type: sfsymbol
            value: star
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: square
              type: sfsymbol
            - value: circle
              type: sfsymbol
            - value: triangle
              type: sfsymbol
            - value: star
              type: sfsymbol
              is_right_answer: true
        """

    static let kListenAudioThenTTSFindTheRightAnswersYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche l'animal qui fait ce bruit"
          - locale: en_US
            value: "Tap the animal that make that noise"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: ipad
          value:
            type: audio
            value: sound_animal_duck
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: Cow
              type: text
            - value: Duck
              type: text
              is_right_answer: true
            - value: Monkey
              type: text
            - value: Pig
              type: text
            - value: Koala
              type: text
            - value: Duck
              type: text
              is_right_answer: true
        """

    static let kListenSpeechThenTTSFindTheRightAnswersYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche la bonne émotion"
          - locale: en_US
            value: "Tap the correct emotion"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: ipad
          value:
            type: speech
            value: happy
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: emotion_picto_angry_leka
              type: image
            - value: emotion_picto_disgust_leka
              type: image
            - value: emotion_picto_fear_leka
              type: image
            - value: emotion_picto_joy_leka
              type: image
              is_right_answer: true
            - value: emotion_picto_sad_leka
              type: image
        """

    static let kRobotLEDThenTTSFindTheRightAnswersYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche la couleur du robot"
          - locale: en_US
            value: "Tap the robot's color"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: color
            value: blue
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: blue
              type: color
              is_right_answer: true
            - value: red
              type: color
        """

    static let kRobotScreenThenTTSFindTheRightAnswersYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche l'émotion du robot"
          - locale: en_US
            value: "Tap the robot's emotion"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: image
            value: robotFaceHappy
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: emotion_picto_angry_leka
              type: image
            - value: emotion_picto_disgust_leka
              type: image
            - value: emotion_picto_fear_leka
              type: image
            - value: emotion_picto_joy_leka
              type: image
              is_right_answer: true
            - value: emotion_picto_sad_leka
              type: image
        """

    static let kObserveImageThenTTSFindTheRightAnswersThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche le sport présenté sur l'image"
          - locale: en_US
            value: "Tap the sport presented on the image"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: ipad
          value:
            type: image
            value: sport_dance_player_man
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: 🕺
              type: emoji
            - value: 🚴
              type: emoji
            - value: 🏃‍♂️
              type: emoji
              is_right_answer: true
        """

    static let kObserveSFSymbolThenTTSFindTheRightAnswersThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche la bonne forme"
          - locale: en_US
            value: "Tap the correct shape"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: ipad
          value:
            type: sfsymbol
            value: star
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: square
              type: sfsymbol
            - value: circle
              type: sfsymbol
            - value: triangle
              type: sfsymbol
            - value: star
              type: sfsymbol
              is_right_answer: true
        """

    static let kListenAudioThenTTSFindTheRightAnswersThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche l'animal qui fait ce bruit"
          - locale: en_US
            value: "Tap the animal that make that noise"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: ipad
          value:
            type: audio
            value: sound_animal_duck
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: Cow
              type: text
            - value: Duck
              type: text
              is_right_answer: true
            - value: Monkey
              type: text
            - value: Pig
              type: text
            - value: Koala
              type: text
            - value: Duck
              type: text
              is_right_answer: true
        """

    static let kListenSpeechThenTTSFindTheRightAnswersThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche la bonne émotion"
          - locale: en_US
            value: "Tap the correct emotion"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: ipad
          value:
            type: speech
            value: happy
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: emotion_picto_angry_leka
              type: image
            - value: emotion_picto_disgust_leka
              type: image
            - value: emotion_picto_fear_leka
              type: image
            - value: emotion_picto_joy_leka
              type: image
              is_right_answer: true
            - value: emotion_picto_sad_leka
              type: image
        """

    static let kRobotColorThenTTSFindTheRightAnswersThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche la couleur du robot"
          - locale: en_US
            value: "Tap the robot's color"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: color
            value: blue
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: blue
              type: color
              is_right_answer: true
            - value: red
              type: color
        """

    static let kRobotScreenThenTTSFindTheRightAnswersThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche l'émotion du robot"
          - locale: en_US
            value: "Tap the robot's emotion"
        interface: touchToSelect
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: image
            value: robotFaceHappy
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: emotion_picto_angry_leka
              type: image
            - value: emotion_picto_disgust_leka
              type: image
            - value: emotion_picto_fear_leka
              type: image
            - value: emotion_picto_joy_leka
              type: image
              is_right_answer: true
            - value: emotion_picto_sad_leka
              type: image
        """

    static let kTTSAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche les images de la même catégorie"
          - locale: en_US
            value: "Tap the same category images"
        interface: touchToSelect
        gameplay: associateCategories
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: pictograms-weather-sun_yellow-0106
              type: image
              category: catA
            - value: pictograms-animals-arctic-penguin_yellow-0088
              type: image
              category: catB
            - value: pictograms-weather-sun_yellow-0106
              type: image
              category: catA
            - value: pictograms-animals-arctic-penguin_yellow-0088
              type: image
              category: catB
            - value: pictograms-animals-arctic-penguin_yellow-0088
              type: image
              category: catB
            - value: pictograms-weather-sun_yellow-0106
              type: image
              category: catA
        """

    static let kTTSFindTheRightOrderYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Trouve l'ordre correct du triathlon"
          - locale: en_US
            value: "Find the correct order of thriathlon"
        interface: touchToSelect
        gameplay: findTheRightOrder
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: 🏊
              type: emoji
            - value: 🚴
              type: emoji
            - value: 🏃‍♂️
              type: emoji
        """

    static let kTTSFindTheRightOrderThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Trouve l'ordre correct du triathlon"
          - locale: en_US
            value: "Find the correct order of thriathlon"
        interface: touchToSelect
        gameplay: findTheRightOrder
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: 🏊
              type: emoji
            - value: 🚴
              type: emoji
            - value: 🏃‍♂️
              type: emoji
        """

    static let kMemoryAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Trouve l'ordre correct du triathlon"
          - locale: en_US
            value: "Find the correct order of thriathlon"
        interface: memory
        gameplay: associateCategories
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: 🍉
              type: emoji
              category: catA
            - value: 🍖
              type: emoji
              category: catD
            - value: 🐕
              type: emoji
              category: catB
            - value: 🍉
              type: emoji
              category: catA
            - value: 🍖
              type: emoji
              category: catD
            - value: 🐕
              type: emoji
              category: catB
            - value: 🍹
              type: emoji
              category: catC
            - value: 🍹
              type: emoji
              category: catC
        """

    static let kTTSOpenPlayYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Choisis les animaux que tu aimes"
          - locale: en_US
            value: "Select animals that you love"
        interface: touchToSelect
        gameplay: openPlay
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: 🐯
              type: emoji
            - value: 🐹
              type: emoji
            - value: 🐷
              type: emoji
            - value: 🐱
              type: emoji
            - value: 🐰
              type: emoji
            - value: 🐮
              type: emoji
        """
}
