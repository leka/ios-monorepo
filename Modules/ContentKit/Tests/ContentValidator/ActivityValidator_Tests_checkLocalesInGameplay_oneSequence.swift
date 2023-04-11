// Leka - iOS Monorepo
// Copyright 2023 APF Frdance handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import ContentKit

final class ActivityValidator_Tests_checkLocalesInGameplay_oneSequence: XCTestCase {

    func test_shouldReturnSuccessWhenLocalesAreAllPresent() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - fr-CA
              - en-US

            gameplay:
              sequence:
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
              sequence:
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

    func test_shouldReturnErrorWhenOneLocaleIsMissingInMultipleSteps() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - fr-CA
              - en-US

            gameplay:
              sequence:
                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user

                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user

                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        let expected = ActivityValidator.Status.missingLocales(locales: ["fr-CA"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenMultipleLocalesAreMissingInOneStep() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - fr-CA
              - en-US

            gameplay:
              sequence:
                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur

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
        let expected = ActivityValidator.Status.missingLocales(locales: ["en-US", "fr-CA"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenDifferentSingleLocalesAreMissingInMultipleSteps() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - fr-CA
              - en-US

            gameplay:
              sequence:
                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: fr-CA
                    value: Instruction donnée à l'utilisateur

                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user

                - instruction:
                  - locale: fr-CA
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        let expected = ActivityValidator.Status.missingLocales(locales: ["en-US", "fr-CA", "fr-FR"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenMultipleLocalesAreMissingInMultipleSteps() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - fr-CA
              - en-US

            gameplay:
              sequence:
                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur

                - instruction:
                  - locale: en-US
                    value: Instruction given to the user

                - instruction:
                  - locale: fr-CA
                    value: Instruction donnée à l'utilisateur
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        let expected = ActivityValidator.Status.missingLocales(locales: ["en-US", "fr-CA", "fr-FR"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenOneLocaleIsUnexpectedInOneStep() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - en-US

            gameplay:
              sequence:
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

                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        let expected = ActivityValidator.Status.unexpectedLocales(locales: ["fr-CA"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenOneLocaleIsUnexpectedInMultipleSteps() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - en-US

            gameplay:
              sequence:
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
        let expected = ActivityValidator.Status.unexpectedLocales(locales: ["fr-CA"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenMultipleLocalesAreUnexpectedInOneStep() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - en-US

            gameplay:
              sequence:
                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: fr-CA
                    value: Instruction donnée à l'utilisateur
                  - locale: fr-BE
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user
                  - locale: en-UK
                    value: Instruction given to the user

                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user

                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        let expected = ActivityValidator.Status.unexpectedLocales(locales: ["fr-CA", "fr-BE", "en-UK"])
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
              sequence:
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
                  - locale: en-UK
                    value: Instruction given to the user

                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: fr-BE
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user
                  - locale: en-UK
                    value: Instruction given to the user
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        let expected = ActivityValidator.Status.unexpectedLocales(locales: ["fr-CA", "fr-BE", "en-UK"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenOneLocaleIsMissingAndOneLocaleIsUnexpectedInOneStep() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - en-US

            gameplay:
              sequence:
                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: fr-CA
                    value: Instruction donnée à l'utilisateur

                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user

                - instruction:
                  - locale: fr-FR
                    value: Instruction donnée à l'utilisateur
                  - locale: en-US
                    value: Instruction given to the user
            """

        // Then
        let result = ActivityValidator.checkLocalesInGameplay(content: content)
        let expected = ActivityValidator.Status.missingAndUnexpectedLocales(
            missing: ["en-US"], unexpected: ["fr-CA"])
        XCTAssertEqual(result, expected)
    }

}
