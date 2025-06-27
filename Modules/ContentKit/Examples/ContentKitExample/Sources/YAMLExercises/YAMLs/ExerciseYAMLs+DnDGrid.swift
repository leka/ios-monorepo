// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

extension ExerciseYAMLs {
    // MARK: Public

    static let kDnDGridAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Rassembler les animaux terrestres et les animaux marins"
          - locale: en_US
            value: "Gather land animals and sea animals"
        interface: dragAndDropGrid
        gameplay: associateCategories
        options:
          shuffle_choices: true
        payload:
          choices:
            - value: Whale
              type: text
              category: catA
            - value: Cat
              type: text
              category: catB
            - value: Dolphin
              type: text
              category: catA
            - value: Dog
              type: text
              category: catB
            - value: Shark
              type: text
              category: catA
            - value: Duck
              type: text
              category: catB
        """

    static let kObserveImageThenDnDGridAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Rassembler les animaux terrestres et les animaux marins"
          - locale: en_US
            value: "Gather land animals and sea animals"
        interface: dragAndDropGrid
        gameplay: associateCategories
        action:
          type: ipad
          value:
            type: image
            value: landscape_cloud_lake
        options:
          shuffle_choices: true
        payload:
          choices:
            - value: Whale
              type: text
              category: catA
            - value: Cat
              type: text
              category: catB
            - value: Dolphin
              type: text
              category: catA
            - value: Dog
              type: text
              category: catB
            - value: Shark
              type: text
              category: catA
            - value: Duck
              type: text
              category: catB
        """

    static let kObserveSFSymbolThenDnDGridAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Rassembler les pingouins et les soleils"
          - locale: en_US
            value: "Gather pinguins and suns"
        interface: dragAndDropGrid
        gameplay: associateCategories
        action:
          type: ipad
          value:
            type: sfsymbol
            value: star
        options:
          shuffle_choices: true
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

    static let kListenAudioThenDnDGridAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Rassembler les formes similaires"
          - locale: en_US
            value: "Gather similar shapes"
        interface: dragAndDropGrid
        gameplay: associateCategories
        action:
          type: ipad
          value:
            type: audio
            value: sound_animal_duck
        options:
          shuffle_choices: true
        payload:
          choices:
            - value: star
              type: sfsymbol
              category: catA
            - value: circle
              type: sfsymbol
              category: catB
            - value: star
              type: sfsymbol
              category: catA
            - value: circle
              type: sfsymbol
              category: catB
            - value: star
              type: sfsymbol
              category: catB
            - value: square
              type: sfsymbol
              category: catA
        """

    static let kListenSpeechThenDnDGridAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Rassembler les emojis similaires"
          - locale: en_US
            value: "Gather similar emojis"
        interface: dragAndDropGrid
        gameplay: associateCategories
        action:
          type: ipad
          value:
            type: speech
            value: fruits
        options:
          shuffle_choices: true
        payload:
          choices:
            - value: 🍉
              type: emoji
              category: catA
            - value: 🍖
              type: emoji
              category: catC
            - value: 🐕
              type: emoji
              category: catB
            - value: 🍉
              type: emoji
              category: catA
            - value: 🍖
              type: emoji
              category: catC
            - value: 🐕
              type: emoji
              category: catB
        """

    static let kRobotColorThenDnDFindTheRightAnswersYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche le sport présenté sur l'image"
          - locale: en_US
            value: "Tap the sport presented on the image"
        interface: dragAndDropGrid
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: color
            value: blue
        options:
          shuffle_choices: true
        payload:
          choices:
            - value: blue
              type: emoji
              category: catA
            - value: blue
              type: emoji
              category: catA
            - value: yellow
              type: emoji
              category: catB
            - value: yellow
              type: emoji
              category: catB
            - value: red
              type: emoji
        """

    static let kRobotScreenThenDnDGridFindTheRightAnswersYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Touche l'émotion du robot"
          - locale: en_US
            value: "Tap the robot's emotion"
        interface: dragAndDropGrid
        gameplay: findTheRightAnswers
        action:
          type: robot
          value:
            type: image
            value: robotFaceHappy
        options:
          shuffle_choices: true
        payload:
          choices:
            - value: emotion_picto_sad_leka
              type: image
              category: catA
            - value: emotion_picto_joy_leka
              type: image
              category: catB
            - value: emotion_picto_sad_leka
              type: image
              category: catA
            - value: emotion_picto_joy_leka
              type: image
              category: catB
            - value: emotion_picto_sad_leka
              type: image
              category: catA
        """
}
