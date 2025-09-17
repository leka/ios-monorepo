// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Yams

public extension Story {
    static var mock: Story {
        let data = mockStoryYaml.data(using: .utf8)!
        let story = try! YAMLDecoder().decode(Story.self, from: data) // swiftlint:disable:this force_try
        return story
    }

    // swiftformat:disable all
    private static let mockStoryYaml = """
    version: 1.0.0

    uuid: FF7618528E194E8CB3A6950E08562D16
    name: hanna_and_leka

    created_at: "2024-03-31T23:33:50.987548"
    last_edited_at: "2024-03-31T23:33:50.987548"
    status: published

    authors:
      - leka

    skills:
      - familiarization_with_leka

    hmi:
      - tablet_robot

    types:
      - one_on_one

    tags:
      - pairing

    locales:
      - en_US
      - fr_FR

    l10n:
      - locale: fr_FR
        details:
          icon: hanna_and_leka

          title: Hanna & Leka
          subtitle:

          short_description: |
            Une aventure joyeuse de Hanna et Leka.

          description: |
            Rejoignez Hanna et Leka pour une série d'aventures captivantes et interactives.

          instructions: |
            - Participez aux jeux et découvrez avec Hanna et Leka.
            - Suivez les indices et aidez-les à résoudre des énigmes.

      - locale: en_US
        details:
          icon: hanna_and_leka

          title: Hanna & Leka
          subtitle:

          short_description: |
            A joyful adventure of Hanna and Leka.

          description: |
            Join Hanna and Leka for a series of captivating and interactive adventures.

          instructions: |
            - Engage in games and discover with Hanna and Leka.
            - Follow clues and help them solve puzzles.

    pages:
      - background: hanna_and_leka_background
        l10n:
          - locale: fr_FR
            items:
              - type: image
                payload:
                  image: hanna_and_leka
                  size: 800
                  text: Hanna et Leka
          - locale: en_US
            items:
              - type: image
                payload:
                  image: hanna_and_leka
                  size: 800
                  text: Hanna and Leka

      - background: hanna_and_leka_background
        l10n:
          - locale: fr_FR
            items:
              - type: text
                payload:
                  text: Chez
              - type: button_image
                payload:
                  idle: hanna
                  pressed: hanna_pressed
                  text: Hanna
              - type: text
                payload:
                  text: ", il y a un nouvel invité: c'est"
              - type: button_image
                payload:
                  idle: leka
                  pressed: leka_pressed
                  text: Leka
                  action:
                    type: robot
                    value: bootyShake
              - type: text
                payload:
                  text: "!"
          - locale: en_US
            items:
              - type: text
                payload:
                  text: At
              - type: button_image
                payload:
                  idle: hanna
                  pressed: hanna_pressed
                  text: Hanna
              - type: text
                payload:
                  text: "there is a new guest: It's"
              - type: button_image
                payload:
                  idle: leka
                  pressed: leka_pressed
                  text: Leka
                  action:
                    type: robot
                    value: bootyShake
              - type: text
                payload:
                  text: "!"

      - background: hanna_and_leka_background
        l10n:
          - locale: fr_FR
            items:
              - type: button_image
                payload:
                  idle: hanna
                  pressed: hanna_pressed
                  text: Hanna
              - type: text
                payload:
                  text: et son
              - type: button_image
                payload:
                  idle: nagib
                  pressed: nagib_pressed
                  text: Papa
              - type: text
                payload:
                  text: jouent ensemble avec
              - type: button_image
                payload:
                  idle: leka
                  pressed: leka_pressed
                  text: Leka
                  action:
                    type: robot
                    value: randomMove
              - type: button_image
                payload:
                  idle: colors
                  text: couleur
                  action:
                    type: activity
                    value: color_bingo_4-A7584D692B23422BB12683FA7BE393BE
          - locale: en_US
            items:
              - type: button_image
                payload:
                  idle: hanna
                  pressed: hanna_pressed
                  text: Hanna
              - type: text
                payload:
                  text: and her
              - type: button_image
                payload:
                  idle: nagib
                  pressed: nagib_pressed
                  text: Father
              - type: text
                payload:
                  text: are playing together with
              - type: button_image
                payload:
                  idle: leka
                  pressed: leka_pressed
                  text: Leka
                  action:
                    type: robot
                    value: randomMove
              - type: button_image
                payload:
                  idle: colors
                  text: couleur
                  action:
                    type: activity
                    value: color_bingo_4-A7584D692B23422BB12683FA7BE393BE

      - background: hanna_and_leka_background
        l10n:
          - locale: fr_FR
            items:
              - type: text
                payload:
                  text: Leka
              - type: button_image
                payload:
                  idle: leka_rolls
                  text: roule
                  action:
                    type: robot
                    value: spin
              - type: text
                payload:
                  text: ", et fait de la"
              - type: button_image
                payload:
                  idle: leka_lights
                  text: lumière
                  action:
                    type: robot
                    value: yellow
          - locale: en_US
            items:
              - type: text
                payload:
                  text: Leka
              - type: button_image
                payload:
                  idle: leka_rolls
                  text: rolls
                  action:
                      type: robot
                      value: spin
              - type: text
                payload:
                  text: "and do some"
              - type: button_image
                payload:
                  idle: leka_lights
                  text: lights
                  action:
                    type: robot
                    value: yellow

      - background: hanna_and_leka_background
        l10n:
          - locale: fr_FR
            items:
              - type: button_image
                payload:
                  idle: hanna
                  pressed: hanna_pressed
                  text: Hanna
              - type: text
                payload:
                  text: "est fière, elle sait reconnaître la"
              - type: button_image
                payload:
                  idle: colors
                  text: couleur
                  action:
                    type: activity
                    value: color_bingo_4-A7584D692B23422BB12683FA7BE393BE
              - type: text
                payload:
                  text: de Leka
          - locale: en_US
            items:
              - type: button_image
                payload:
                  idle: hanna
                  pressed: hanna_pressed
                  text: Hanna
              - type: text
                payload:
                  text: "is proud she can recognize the"
              - type: button_image
                payload:
                  idle: colors
                  text: color
                  action:
                    type: activity
                    value: color_bingo_4-A7584D692B23422BB12683FA7BE393BE
              - type: text
                payload:
                  text: of Leka

      - background: hanna_and_leka_background
        l10n:
          - locale: fr_FR
            items:
              - type: image
                payload:
                  image: hanna_and_leka
                  size: 800
                  text: Fin
          - locale: en_US
            items:
              - type: image
                payload:
                  image: hanna_and_leka
                  size: 800
                  text: The end
    """
    // swiftformat:enable all
}
