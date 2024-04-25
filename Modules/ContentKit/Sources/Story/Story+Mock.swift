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
    name: story_1

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
        items:
          - type: image
            payload:
              image: hanna_and_leka
              size: 800
              text:
                - locale: fr_FR
                  value: Hanna et Leka
                - locale: en_US
                  value: Hanna and Leka

      - background: hanna_and_leka_background
        items:
          - type: text
            payload:
              text:
                - locale: fr_FR
                  value: Chez
                - locale: en_US
                  value: At

          - type: button
            payload:
              image: hanna
              pressed: hanna_pressed
              text:
                - locale: fr_FR
                  value: Hanna
                - locale: en_US
                  value: Hanna

          - type: text
            payload:
              text:
                - locale: fr_FR
                  value: ", il y a un nouvel invité: c'est"
                - locale: en_US
                  value: "there is a new guest: It's"

          - type: button
            payload:
              image: leka
              pressed: leka_pressed
              text:
                - locale: fr_FR
                  value: Leka
                - locale: en_US
                  value: Leka
              action: bootyShake

          - type: text
            payload:
              text:
                - locale: fr_FR
                  value: !
                - locale: en_US
                  value: !

      - background: hanna_and_leka_background
        items:
          - type: button
            payload:
              image: hanna
              pressed: hanna_pressed
              text:
                - locale: fr_FR
                  value: Hanna
                - locale: en_US
                  value: Hanna

          - type: text
            payload:
              text:
                - locale: fr_FR
                  value: et son
                - locale: en_US
                  value: and her

          - type: button
            payload:
              image: nagib
              pressed: nagib_pressed
              text:
                - locale: fr_FR
                  value: Papa
                - locale: en_US
                  value: Father

          - type: text
            payload:
              text:
                - locale: fr_FR
                  value: jouent ensemble avec
                - locale: en_US
                  value: are playing together with

          - type: button
            payload:
              image: leka
              pressed: leka_pressed
              text:
                - locale: fr_FR
                  value: Leka
                - locale: en_US
                  value: Leka
              action: randomMove

      - background: hanna_and_leka_background
        items:
          - type: text
            payload:
              text:
                - locale: fr_FR
                  value: Leka
                - locale: en_US
                  value: Leka

          - type: button
            payload:
              image: leka_rolls
              text:
                - locale: fr_FR
                  value: roule
                - locale: en_US
                  value: rolls
              action: spin

          - type: text
            payload:
              text:
                - locale: fr_FR
                  value: ", et fait de la"
                - locale: en_US
                  value: and do some

          - type: button
            payload:
              image: leka_lights
              text:
                - locale: fr_FR
                  value: lumière
                - locale: en_US
                  value: lights
              action: yellow

      - background: hanna_and_leka_background
        items:
          - type: button
            payload:
              image: hanna
              pressed: hanna_pressed
              text:
                - locale: fr_FR
                  value: Hanna
                - locale: en_US
                  value: Hanna

          - type: text
            payload:
              text:
                - locale: fr_FR
                  value: "est fière, elle sait reconnaître la"
                - locale: en_US
                  value: is proud she can recognize the

          - type: activity_button
            payload:
              image: colors
              text:
                - locale: fr_FR
                  value: couleur
                - locale: en_US
                  value: color
              activity: A7584D692B23422BB12683FA7BE393BE

          - type: text
            payload:
              text:
                - locale: fr_FR
                  value: de Leka
                - locale: en_US
                  value: of Leka

      - background: hanna_and_leka_background
        items:
          - type: image
            payload:
              image: hanna_and_leka
              size: 800
              text:
                - locale: fr_FR
                  value: Fin
                - locale: en_US
                  value: The end
    """
    // swiftformat:enable all
}
