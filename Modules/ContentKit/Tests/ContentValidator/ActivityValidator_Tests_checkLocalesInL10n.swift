// Leka - iOS Monorepo
// Copyright 2023 APF Frdance handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import ContentKit

final class ActivityValidator_Tests_checkLocalesInL10n: XCTestCase {

    func test_shouldReturnSuccessWhenLocalesAreAllPresent() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - fr-CA
              - en-US

            l10n:
              - locale: fr-FR
              - locale: fr-CA
              - locale: en-US
            """

        // Then
        let result = ActivityValidator.checkLocalesInL10n(content: content)
        XCTAssertEqual(result, .success)
    }

    func test_shouldReturnErrorWhenOneLocaleIsMissing() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - fr-CA
              - en-US

            l10n:
              - locale: fr-FR
              - locale: en-US
            """

        // Then
        let result = ActivityValidator.checkLocalesInL10n(content: content)
        let expected = ActivityValidator.Status.missingLocales(locales: ["fr-CA"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenMultipleLocalesAreMissing() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - fr-CA
              - en-US
              - en-UK

            l10n:
              - locale: fr-FR
              - locale: en-US
            """

        // Then
        let result = ActivityValidator.checkLocalesInL10n(content: content)
        let expected = ActivityValidator.Status.missingLocales(locales: ["fr-CA", "en-UK"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenOneLocaleIsUnexpected() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - en-US

            l10n:
              - locale: fr-FR
              - locale: fr-CA
              - locale: en-US
            """

        // Then
        let result = ActivityValidator.checkLocalesInL10n(content: content)
        let expected = ActivityValidator.Status.unexpectedLocales(locales: ["fr-CA"])
        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenMultipleLocaleAreUnexpected() {
        // Given

        // When
        let content: String = """
            locales:
              - fr-FR
              - en-US

            l10n:
              - locale: fr-FR
              - locale: fr-CA
              - locale: en-US
              - locale: en-UK
            """

        // Then
        let result = ActivityValidator.checkLocalesInL10n(content: content)
        let expected = ActivityValidator.Status.unexpectedLocales(locales: ["fr-CA", "en-UK"])
        XCTAssertEqual(result, expected)
    }
}
