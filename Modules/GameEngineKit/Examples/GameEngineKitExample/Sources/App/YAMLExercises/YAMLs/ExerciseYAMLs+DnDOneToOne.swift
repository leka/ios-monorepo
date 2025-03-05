// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit

// swiftlint:disable identifier_name

extension ExerciseYAMLs {
    // MARK: Public

    static let kDnDOneToOneFindTheRightOrderYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: sequencing_dressing_up_1
              type: image
            - value: sequencing_dressing_up_2
              type: image
              already_ordered: true
            - value: sequencing_dressing_up_3
              type: image
            - value: sequencing_dressing_up_4
              type: image
            - value: sequencing_dressing_up_5
              type: image
        """

    static let kObserveImageThenDnDOneToOneFindTheRightOrderYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
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
            - value: sequencing_dressing_up_1
              type: image
            - value: sequencing_dressing_up_2
              type: image
            - value: sequencing_dressing_up_3
              type: image
            - value: sequencing_dressing_up_4
              type: image
            - value: sequencing_dressing_up_5
              type: image
              already_ordered: true

        """

    static let kObserveSFSymbolThenDnDOneToOneFindTheRightOrderYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
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
            - value: 1
              type: text
              already_ordered: true
            - value: 2
              type: text
            - value: 3
              type: text
            - value: 4
              type: text
            - value: 5
              type: text
              already_ordered: true
            - value: 6
              type: text
        """

    static let kListenAudioThenDnDOneToOneFindTheRightOrderYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
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
            - value: 1.circle
              type: sfsymbol
            - value: 2.circle
              type: sfsymbol
            - value: 3.circle
              type: sfsymbol
              already_ordered: true
            - value: 4.circle
              type: sfsymbol
        """

    static let kListenSpeechThenDnDOneToOneFindTheRightOrderYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
        action:
          type: ipad
          value:
            type: speech
            value: red blue yellow
        options:
          shuffle_choices: true
          validate: false
        payload:
          choices:
            - value: red
              type: color
            - value: blue
              type: color
            - value: yellow
              type: color
        """

    static let kRobotLEDThenDnDOneToOneFindTheRightOrderYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
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
            - value: 🏊
              type: emoji
            - value: 🚴
              type: emoji
            - value: 🏃‍♂️
              type: emoji
        """

    static let kRobotScreenThenDnDOneToOneFindTheRightOrderYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
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
            - value: 1.circle
              type: sfsymbol
            - value: 2.circle
              type: sfsymbol
            - value: 3.circle
              type: sfsymbol
              already_ordered: true
            - value: 4.circle
              type: sfsymbol
        """

    static let kDnDOneToOneFindTheRightOrderThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: sequencing_dressing_up_1
              type: image
            - value: sequencing_dressing_up_2
              type: image
              already_ordered: true
            - value: sequencing_dressing_up_3
              type: image
            - value: sequencing_dressing_up_4
              type: image
            - value: sequencing_dressing_up_5
              type: image
        """

    static let kObserveImageThenDnDOneToOneFindTheRightOrderThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
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
            - value: sequencing_dressing_up_1
              type: image
            - value: sequencing_dressing_up_2
              type: image
            - value: sequencing_dressing_up_3
              type: image
            - value: sequencing_dressing_up_4
              type: image
            - value: sequencing_dressing_up_5
              type: image
              already_ordered: true

        """

    static let kObserveSFSymbolThenDnDOneToOneFindTheRightOrderThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
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
            - value: 1
              type: text
              already_ordered: true
            - value: 2
              type: text
            - value: 3
              type: text
            - value: 4
              type: text
            - value: 5
              type: text
              already_ordered: true
            - value: 6
              type: text
        """

    static let kListenAudioThenDnDOneToOneFindTheRightOrderThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
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
            - value: 1.circle
              type: sfsymbol
            - value: 2.circle
              type: sfsymbol
            - value: 3.circle
              type: sfsymbol
              already_ordered: true
            - value: 4.circle
              type: sfsymbol
        """

    static let kListenSpeechThenDnDOneToOneFindTheRightOrderThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
        action:
          type: ipad
          value:
            type: speech
            value: red blue yellow
        options:
          shuffle_choices: true
          validate: true
        payload:
          choices:
            - value: red
              type: color
            - value: blue
              type: color
            - value: yellow
              type: color
        """

    static let kRobotLEDThenDnDOneToOneFindTheRightOrderThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
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
            - value: 🏊
              type: emoji
            - value: 🚴
              type: emoji
            - value: 🏃‍♂️
              type: emoji
        """

    static let kRobotScreenThenDnDOneToOneFindTheRightOrderThenValidateYaml: String =
        """
        instructions:
          - locale: fr_FR
            value: "Met les choix dans le bon ordre"
          - locale: en_US
            value: "Find the right order"
        interface: dragAndDropOneToOne
        gameplay: findTheRightOrder
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
            - value: 1.circle
              type: sfsymbol
            - value: 2.circle
              type: sfsymbol
            - value: 3.circle
              type: sfsymbol
              already_ordered: true
            - value: 4.circle
              type: sfsymbol
        """
}

// swiftlint:enable identifier_name
