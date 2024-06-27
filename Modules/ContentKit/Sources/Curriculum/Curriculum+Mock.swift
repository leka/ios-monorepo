// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Yams

public extension Curriculum {
    static var mock: Curriculum {
        let data = mockCurriculumYaml.data(using: .utf8)!
        let curriculum = try! YAMLDecoder().decode(Curriculum.self, from: data) // swiftlint:disable:this force_try
        return curriculum
    }

    // swiftformat:disable all
    private static let mockCurriculumYaml = """
        uuid: D85443FD58A7431DAAAF94FAC0C0FDDE
        name: sample_1

        status: published

        created_at: "2024-03-21T10:29:54.235434"
        last_edited_at: "2024-03-21T15:26:56.185294"
        authors:
          - leka
          - aurore_kiesler
          - julie_tuil

        locales:
          - en_US
          - fr_FR

        skills:
          - spatial_understanding
          - communication/non_verbal_communication/gestures

        tags:
          - tag_one
          - tag_two
          - tag_three

        hmi:
        - robot
        - magic_cards
        - tablet_robot

        l10n:
          - locale: fr_FR
            details:
            icon: sample_1

            title: Sample 1 - Le titre/nom du curriculum
            subtitle: Le sous-titre du curriculum

            abstract: |
              Courte description du curriculum sur plusieurs lignes
              Si besoin!
              Et en markdown **simple** seulement

            description: |
              ## Longues description en markdown plus complexe si on veut

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
            icon: sample_1

            title: Sample 1 - The title/name of the curriculum
            subtitle: The subtitle of the curriculum

            abstract: |
              Short description of the curriculum on several lines
              If needed!
              And in **simple** markdown only

            description: |
              ## Long description in more complex markdown if we want

              Lorem markdownum recepta avidum, missa de quam patientia, antris: cum defuit,
              Titan repetemus nomine, ignare. Quod ad aura, et non quod vidisse utque ulla:

              - Pro inposuit tibi orsa tum artes ferox
              - Acmon plausu qua agrestum situs virgo in
              - Vacuus a pendens rostro non si pharetrae
              - Haeremusque quos auxiliaris coniunx
              - Repulsa impediunt munera teneri fallebat
              - Bracchia frustra telo Iovis faucibus casus

        activities:
          - 0123456789ABCDEF0123456789ABCDEF
          - 5A670B59EB214A6AA11AB39D64D63990
          - 6102794F02D3423482E243BCBC7F8CA8
        """
    // swiftformat:enable all
}
