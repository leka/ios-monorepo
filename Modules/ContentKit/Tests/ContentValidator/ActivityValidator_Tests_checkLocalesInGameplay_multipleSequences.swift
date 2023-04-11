// Leka - iOS Monorepo
// Copyright 2023 APF Frdance handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import ContentKit

final class ActivityValidator_Tests_checkLocalesInGameplay_multipleSequences: XCTestCase {

    func test_shouldReturnSuccessWhenLocalesAreAllPresent() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - fr-CA
              - en-US

            gameplay:
              sequences:
                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user

                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user

                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        XCTAssertEqual(result, .success)
    }

    func test_shouldReturnErrorWhenOneLocaleIsMissingInOneStep() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - fr-CA
              - en-US

            gameplay:
              sequences:
                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user

                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user

                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        let expected = ActivityValidator.Status.missingLocales(locales: ["fr-CA"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenMutltipleLocalesAreMissingInMultipleSteps() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - fr-CA
              - en-US

            gameplay:
              sequences:
                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                    - instruction:
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user

                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user

                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: en-US
                          value: Instruction given to the user
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        let expected = ActivityValidator.Status.missingLocales(locales: ["fr-CA", "fr-FR", "en-US"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenMultipleLocalesAreUnexpectedInMultipleSteps() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - en-US

            gameplay:
              sequences:
                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-BE
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user

                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-BE
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user

                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-BE
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-BE
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        let expected = ActivityValidator.Status.unexpectedLocales(locales: ["fr-CA", "fr-BE"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenMultipleLocalesAreMissingAndUnexpectedInMultipleSteps() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - en-US

            gameplay:
              sequences:
                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-BE
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-BE
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user

                - sequence:
                    - instruction:
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-BE
                          value: Instruction donnée à l'utilisateur
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user

                - sequence:
                    - instruction:
                        - locale: fr-FR
                          value: Instruction donnée à l'utilisateur
                        - locale: fr-BE
                          value: Instruction donnée à l'utilisateur
                        - locale: en-US
                          value: Instruction given to the user
                    - instruction:
                        - locale: fr-CA
                          value: Instruction donnée à l'utilisateur
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        let expected = ActivityValidator.Status.missingAndUnexpectedLocales(
            missing: ["fr-FR", "en-US"], unexpected: ["fr-CA", "fr-BE"])
        XCTAssertEqual(result, expected)
    }
}
