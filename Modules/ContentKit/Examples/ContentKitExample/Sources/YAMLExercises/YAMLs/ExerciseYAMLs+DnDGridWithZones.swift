// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable identifier_name

extension ExerciseYAMLs {
    // MARK: Public

    static let kDnDGridWithZonesAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: emotion_picto_angry_leka
              type: image
              category: catB
            - value: emotion_picto_disgust_leka
              type: image
              category: catB
            - value: emotion_picto_fear_leka
              type: image
              category: catB
            - value: emotion_picto_joy_leka
              type: image
              category: catA
            - value: emotion_picto_sad_leka
              type: image
              category: catB
            - value: Émotions agréables
              type: text
              category: catA
              is_dropzone: true
            - value: Émotions désagréables
              type: text
              category: catB
              is_dropzone: true
        """

    static let kObserveImageThenDnDGridWithZonesAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
              category: catA
            - value: 🚴
              type: emoji
              category: catA
            - value: 🏃‍♂️
              type: emoji
              category: catA
            - value: 🦘
              type: emoji
              category: catB
            - value: 🦑
              type: emoji
              category: catB
            - value: 🫎
              type: emoji
              category: catB
            - value: Sports
              type: text
              category: catA
              is_dropzone: true
            - value: Animaux
              type: text
              category: catB
              is_dropzone: true
        """

    static let kObserveSFSymbolThenDnDGridWithZonesAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
            - value: 🕺
              type: emoji
              category: catA
            - value: 🦘
              type: emoji
              category: catB
            - value: Sports
              type: text
              category: catA
              is_dropzone: true
            - value: Animaux
              type: text
              category: catB
              is_dropzone: true
        """

    static let kListenAudioThenDnDGridWithZonesAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
            - value: Vache
              type: text
              category: catB
            - value: Cochon
              type: text
              category: catB
            - value: Poisson
              type: text
              category: catA
            - value: Requin
              type: text
              category: catA
            - value: Koala
              type: text
              category: catB
            - value: Baleine
              type: text
              category: catA
            - value: Animaux marins
              type: text
              category: catA
              is_dropzone: true
            - value: Animaux terrestres
              type: text
              category: catB
              is_dropzone: true
        """

    static let kListenSpeechThenDnDGridWithZonesAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
            - value: cloud.sun
              type: sfsymbol
              category: catA
              is_dropzone: true
            - value: car.2
              type: sfsymbol
              category: catB
              is_dropzone: true
            - value: sun.max
              type: sfsymbol
              category: catA
            - value: car
              type: sfsymbol
              category: catB
            - value: sun.rain
              type: sfsymbol
              category: catA
            - value: car.side
              type: sfsymbol
              category: catB
            - value: cloud.snow
              type: sfsymbol
              category: catA
            - value: truck.box
              type: sfsymbol
              category: catB
        """

    static let kRobotLEDThenDnDGridWithZonesAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
              category: catA
              is_dropzone: true
            - value: red
              type: color
              category: catB
              is_dropzone: true
            - value: blue
              type: color
              category: catA
            - value: red
              type: color
              category: catB
            - value: blue
              type: color
              category: catA
            - value: red
              type: color
              category: catB
            - value: yellow
              type: color
        """

    static let kRobotScreenThenDnDGridWithZonesAssociateCategoriesYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
            - value: 🏃‍♂️
              type: emoji
              category: catA
            - value: 🫎
              type: emoji
              category: catB
            - value: Sports
              type: text
              category: catA
              is_dropzone: true
            - value: Animaux
              type: text
              category: catB
              is_dropzone: true
        """

    static let kDnDGridWithZonesAssociateCategoriesThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: emotion_picto_angry_leka
              type: image
              category: catB
            - value: emotion_picto_disgust_leka
              type: image
              category: catB
            - value: emotion_picto_fear_leka
              type: image
              category: catB
            - value: emotion_picto_joy_leka
              type: image
              category: catA
            - value: emotion_picto_sad_leka
              type: image
              category: catB
            - value: Émotions agréables
              type: text
              category: catA
              is_dropzone: true
            - value: Émotions désagréables
              type: text
              category: catB
              is_dropzone: true
        """

    static let kObserveImageThenDnDGridWithZonesAssociateCategoriesThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
              category: catA
            - value: 🚴
              type: emoji
              category: catA
            - value: 🏃‍♂️
              type: emoji
              category: catA
            - value: 🦘
              type: emoji
              category: catB
            - value: 🦑
              type: emoji
              category: catB
            - value: 🫎
              type: emoji
              category: catB
            - value: Sports
              type: text
              category: catA
              is_dropzone: true
            - value: Animaux
              type: text
              category: catB
              is_dropzone: true
        """

    static let kObserveSFSymbolThenDnDGridWithZonesAssociateCategoriesThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
            - value: 🕺
              type: emoji
              category: catA
            - value: 🦘
              type: emoji
              category: catB
            - value: Sports
              type: text
              category: catA
              is_dropzone: true
            - value: Animaux
              type: text
              category: catB
              is_dropzone: true
        """

    static let kListenAudioThenDnDGridWithZonesAssociateCategoriesThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
            - value: Vache
              type: text
              category: catB
            - value: Cochon
              type: text
              category: catB
            - value: Poisson
              type: text
              category: catA
            - value: Requin
              type: text
              category: catA
            - value: Koala
              type: text
              category: catB
            - value: Baleine
              type: text
              category: catA
            - value: Animaux marins
              type: text
              category: catA
              is_dropzone: true
            - value: Animaux terrestres
              type: text
              category: catB
              is_dropzone: true
        """

    static let kListenSpeechThenDnDGridWithZonesAssociateCategoriesThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
            - value: cloud.sun
              type: sfsymbol
              category: catA
              is_dropzone: true
            - value: car.2
              type: sfsymbol
              category: catB
              is_dropzone: true
            - value: sun.max
              type: sfsymbol
              category: catA
            - value: car
              type: sfsymbol
              category: catB
            - value: sun.rain
              type: sfsymbol
              category: catA
            - value: car.side
              type: sfsymbol
              category: catB
            - value: cloud.snow
              type: sfsymbol
              category: catA
            - value: truck.box
              type: sfsymbol
              category: catB
        """

    static let kRobotLEDThenDnDGridWithZonesAssociateCategoriesThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
              category: catA
              is_dropzone: true
            - value: red
              type: color
              category: catB
              is_dropzone: true
            - value: blue
              type: color
              category: catA
            - value: red
              type: color
              category: catB
            - value: blue
              type: color
              category: catA
            - value: red
              type: color
              category: catB
            - value: yellow
              type: color
        """

    static let kRobotScreenThenDnDGridWithZonesAssociateCategoriesThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans la bonne case"
          - locale: en_US
            value: "Drop choices into the right dropzone"
        interface: dragAndDropGridWithZones
        gameplay: associateCategories
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
            - value: 🏃‍♂️
              type: emoji
              category: catA
            - value: 🫎
              type: emoji
              category: catB
            - value: Sports
              type: text
              category: catA
              is_dropzone: true
            - value: Animaux
              type: text
              category: catB
              is_dropzone: true
        """

    static let kDnDGridWithZonesOpenPlayYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "T'aimes / T'aime pas"
          - locale: en_US
            value: "Like it or not "
        interface: dragAndDropGridWithZones
        gameplay: openPlay
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: 😍
              type: emoji
              is_dropzone: true
            - value: ☹️
              type: emoji
              is_dropzone: true
            - value: 🍏
              type: emoji
            - value: 🌮
              type: emoji
            - value: 🍓
              type: emoji
            - value: 🍩
              type: emoji
            - value: 🍊
              type: emoji
            - value: 💩
              type: emoji
        """
}

// swiftlint:enable identifier_name
