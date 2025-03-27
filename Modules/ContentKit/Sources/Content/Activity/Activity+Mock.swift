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

    created_at: 2024-02-28T12:53:48+00:00
    last_edited_at: 2024-02-28T12:53:48+00:00

    status: published

    authors:
      - leka
      - aurore_kiesler
      - julie_tuil

    skills:
      - spatial_understanding
      - communication/non_verbal_communication/gestures
      - communication/verbal_communication/receptive_language
      - association
      - association/matching
      - association/sorting
      - association/ordering
      - attention
      - attention/sustained_attention
      - attention/transition
      - attention/joint_attention

    tags:
      - tag_one
      - tag_two
      - tag_three

    hmi:
      - robot
      - magic_cards
      - tablet_robot

    types:
      - one_on_one
      - group

    locales:
      - en_US
      - fr_FR

    l10n:
      - locale: fr_FR
        details:
          icon: placeholder_2

          title: Activité d'exemple
          subtitle: pour le développement

          short_description: >
            Nunc Corinthiaci anilem, rerum primo et ambos fata? Et Drya aliis abest, *adeunt
            deprenduntur* vidi age: venit *cuncti*, aures. Sentit tale nubibus!

          description: |
            Lorem **markdownum arduus salve** sermone quanto fuit: ait nunc placitas precor
            **Mercurium novi**: terra nec. Nullo si auctor tenentis **verbis**; sed ore.
            Nisi sermone procul, et diu turbantes, opem nitidis, aera ad esse Pico refugit
            iugulum? Gradus non verbis humana **rursus aeternum vincetis** gaudet inpia
            puro, est.

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
          icon: placeholder_2

          title: Sample activity
          subtitle: for development

          short_description: >
            Nunc Corinthiaci anilem, rerum primo et ambos fata? Et Drya aliis abest, *adeunt
            deprenduntur* vidi age: venit *cuncti*, aures. Sentit tale nubibus!

          description: |
            Lorem **markdownum arduus salve** sermone quanto fuit: ait nunc placitas precor
            **Mercurium novi**: terra nec. Nullo si auctor tenentis **verbis**; sed ore.
            Nisi sermone procul, et diu turbantes, opem nitidis, aera ad esse Pico refugit
            iugulum? Gradus non verbis humana **rursus aeternum vincetis** gaudet inpia
            puro, est.

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
        shuffle_exercises: false
        shuffle_groups: false

      exercise_groups:
        - group:
            - instructions:
                - locale: fr_FR
                  value: Touch la pastèque
                - locale: en_US
                  value: Touch the watermelon
              interface: touchToSelect
              gameplay: findTheRightAnswers
              payload:
                shuffle_choices: true
                choices:
                  - value: 🍉
                    type: emoji
                    is_right_answer: true
                  - value: 🍌
                    type: emoji
                  - value: 🍒
                    type: emoji
                  - value: 🥝
                    type: emoji

            - instructions:
                - locale: fr_FR
                  value: Touch le carré
                - locale: en_US
                  value: Touch the square
              interface: touchToSelect
              gameplay: findTheRightAnswers
              payload:
                shuffle_choices: true
                choices:
                  - value: circle
                    type: sfsymbol
                  - value: square
                    type: sfsymbol
                    is_right_answer: true
                  - value: triangle
                    type: sfsymbol
                  - value: rhombus
                    type: sfsymbol

            - instructions:
                - locale: fr_FR
                  value: Touch le rond jaune
                - locale: en_US
                  value: Touch the yellow circle
              interface: touchToSelect
              gameplay: findTheRightAnswers
              payload:
                shuffle_choices: true
                choices:
                  - value: yellow
                    type: color
                    is_right_answer: true
                  - value: red
                    type: color
                  - value: green
                    type: color
                  - value: blue
                    type: color
    """
    // swiftformat:enable all
}
