// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit

extension ExerciseYAMLs {
    // MARK: Public

    static let kHideAndSeekYaml: String =
        """
            instructions:
                - locale: fr_FR
                  value: Trouve Leka !
                - locale: en_US
                  value: Find Leka!
            interface: hideAndSeek
        """

    static let kDiscoverLekaYaml: String =
        """
            instructions:
                - locale: fr_FR
                  value: Observe Leka
                - locale: en_US
                  value: Observe Leka
            interface: pairing
        """

    static let kColorMediatorYaml: String =
        """
            interface: colorMediator
        """

    static let kColorMusicPadYaml: String =
        """
            interface: colorMusicPad
        """

    static let kGamepadArrowPadYaml: String =
        """
            instructions:
                - locale: fr_FR
                  value: Appuie sur une des flèches pour téléguider Leka dans la direction de ton choix
                - locale: en_US
                  value: Press one of the arrows to remotely guide Leka in the direction of your choice
            interface: gamepadArrowPad
        """

    static let kGamepadArrowPadColorPadYaml: String =
        """
            instructions:
                - locale: fr_FR
                  value: Contrôle Leka avec la télécommande, fais-le se déplacer, changer de couleur ou lance le renforçateur de ton choix
                - locale: en_US
                  value: Control Leka with the remote control, make him move, change color or throw the reinforcer of your choice
            interface: gamepadArrowPadColorPad
        """

    static let kGamepadColorPadYaml: String =
        """
            instructions:
                - locale: fr_FR
                  value: Change la couleur de Leka en appuyant sur les boutons de couleur
                - locale: en_US
                  value: Change Leka's color by pressing the color buttons
            interface: gamepadColorPad
        """

    static let kGamepadJoystickColorPadYaml: String =
        """
            instructions:
                - locale: fr_FR
                  value: Contrôle Leka avec la télécommande, fais le se déplacer, changer de couleur ou lance le renforçateur de ton choix
                - locale: en_US
                  value: Control Leka with the remote control, make him move, change color or throw the reinforcer of your choice
            interface: gamepadJoyStickColorPad
        """

    static let kDanceFreezeYaml: String =
        """
          interface: danceFreeze
          payload:
            songs:
              - audio: Early_Bird
                labels:
                  - locale: fr_FR
                    value:
                      name: Réveil Énergique
                      icon: early_bird
                  - locale: en_US
                    value:
                      name: Early Bird
                      icon: early_bird
              - audio: Empty_Page
                labels:
                  - locale: fr_FR
                    value:
                      name: Nouvelle Aventure
                      icon: empty_page
                  - locale: en_US
                    value:
                      name: Empty Page
                      icon: empty_page
              - audio: Giggly_Squirrel
                labels:
                  - locale: fr_FR
                    value:
                      name: Écureuil Rieur
                      icon: giggly_squirrel
                  - locale: en_US
                    value:
                      name: Giggly Squirrel
                      icon: giggly_squirrel
              - audio: Hands_On
                labels:
                  - locale: fr_FR
                    value:
                      name: En Avant la Créativité
                      icon: hands_on
                  - locale: en_US
                    value:
                      name: Hands On
                      icon: hands_on
              - audio: Happy_Days
                labels:
                  - locale: fr_FR
                    value:
                      name: Bonne Journée
                      icon: happy_days
                  - locale: en_US
                    value:
                      name: Happy Days
                      icon: happy_days
              - audio: In_The_Game
                labels:
                  - locale: fr_FR
                    value:
                      name: Course Folle
                      icon: in_the_game
                  - locale: en_US
                    value:
                      name: In The Game
                      icon: in_the_game
              - audio: Little_by_little
                labels:
                  - locale: fr_FR
                    value:
                      name: Petit à Petit
                      icon: little_by_little
                  - locale: en_US
                    value:
                      name: Little by Little
                      icon: little_by_little
        """

    static let kMediumSuperSimonYaml: String =
        """
          interface: superSimon
          payload:
            level: medium
        """

    static let kMusicalInstrumentYaml: String =
        """
          instructions:
            - locale: fr_FR
              value: Joue du Xylophone avec Leka
            - locale: en_US
              value: Play the Xylophone with Leka
          interface: musicalInstruments
          payload:
            instrument: xylophone
            scale: majorHeptatonic
        """

    static let kMelodyYaml: String =
        """
          instructions:
            - locale: fr_FR
              value: Joue les notes de la même couleur que Leka
            - locale: en_US
              value: Play the notes of the same color as Leka
          interface: melody
          payload:
            instrument: xylophone
            songs:
              - audio: Under_The_Moonlight
                labels:
                  - locale: fr_FR
                    value:
                      name: Au Clair de la Lune
                      icon: under_the_moonlight
                  - locale: en_US
                    value:
                      name: Under the Moonlight
                      icon: under_the_moonlight
              - audio: A_Green_Mouse
                labels:
                  - locale: fr_FR
                    value:
                      name: Une Souris Verte
                      icon: green_mouse
                  - locale: en_US
                    value:
                      name: A Green Mouse
                      icon: green_mouse
              - audio: Twinkle_Twinkle_Little_Star
                labels:
                  - locale: fr_FR
                    value:
                      name: Ah Vous Dirais-je Maman
                      icon: ah_vous_dirais_je_maman
                  - locale: en_US
                    value:
                      name: Twinkle Twinkle Little Star
                      icon: twinkle_twinkle_little_star
              - audio: Oh_The_Crocodiles
                labels:
                  - locale: fr_FR
                    value:
                      name: Ah les Crocodiles
                      icon: oh_the_crocodiles
                  - locale: en_US
                    value:
                      name: Oh the Crocodiles
                      icon: oh_the_crocodiles
              - audio: Happy_Birthday
                labels:
                  - locale: fr_FR
                    value:
                      name: Joyeux Anniversaire
                      icon: happy_birthday
                  - locale: en_US
                    value:
                      name: Happy Birthday
                      icon: happy_birthday
        """
}
