// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Yams

public extension Activity {
    static var mock: Activity {
        let data = mockActivityYaml.data(using: .utf8)!
        let activity = try! YAMLDecoder().decode(Activity.self, from: data) // swiftlint:disable:this force_try
        return activity
    }

    // swiftformat:disable all
    private static let mockActivityYaml = """
        version: 1.0.0

        uuid: E7EE9CA4B13B49AF96CD77A9DF90833B
        name: mock_activity

        status: published

        authors:
          - leka
          - aurore_kiesler
          - julie_tuil

        skills:
          - spatial_understanding
          - recognition/animals
          - communication/non_verbal_communication/gestures

        tags:
          - tag_one
          - tag_two
          - tag_three

        hmi:
          - robot
          - magic_cards
          - tablet_robot

        locales:
          - en_US
          - fr_FR

        l10n:
          - locale: fr_FR
            details:
              icon: name_of_the_activity-icon-fr_FR.svg

              title: Activité d'exemple
              subtitle: pour le développement

              description: |
                Activité d'exemple utilisée pour le développement de l'application

              instructions: |
                ## Longues instructions en markdown plus complexe si on veut

                Lorem markdownum recepta avidum, missa de quam patientia, antris: cum defuit,
                Titan repetemus nomine, ignare. Quod ad aura, et non quod vidisse utque ulla:

                - Pro inposuit tibi orsa tum artes ferox
                - Acmon plausu qua agrestum situs virgo in
                - Vacuus a pendens rostro non si pharetrae
                - Haeremusque quos auxiliaris coniunx
                - Repulsa impediunt munera teneri fallebat
                - Bracchia frustra telo Iovis faucibus casus

          - locale: en_US
            details:
              icon: name_of_the_activity-icon-en_US.svg

              title: Sample activity
              subtitle: for development

              description: |
                Sample activity used for the development of the application

              instructions: |
                ## Long instructions in markdown more complex if we want

                Lorem markdownum recepta avidum, missa de quam patientia, antris: cum defuit,
                Titan repetemus nomine, ignare. Quod ad aura, et non quod vidisse utque ulla:

                - Pro inposuit tibi orsa tum artes ferox
                - Acmon plausu qua agrestum situs virgo in
                - Vacuus a pendens rostro non si pharetrae
                - Haeremusque quos auxiliaris coniunx
                - Repulsa impediunt munera teneri fallebat
                - Bracchia frustra telo Iovis faucibus casus

        exercises_payload:
          options:
            shuffle_exercises: true
            shuffle_groups: true

          exercise_groups:
            - group:
                - instructions:
                    - locale: fr_FR
                      value: Touch le rond jaune
                    - locale: en_US
                      value: Touch the yellow circle
                  interface: touchToSelect
                  gameplay: findTheRightAnswers
                  payload:
                    choices:
                      - value: yellow
                        type: color
                        isRightAnswer: true
                      - value: red
                        type: color
                      - value: green
                        type: color
                      - value: blue
                        type: color
        """
    // swiftformat:enable all
}
