// Leka - iOS Monorepo
// Copyright 2023 APF Frdance handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import ContentKit

final class ActivityValidator_Tests_checkSchemaReferences: XCTestCase {

    func test_shouldReturnSuccessdWhenSchemasAreTheSame() {
        // Given

        // When
        let content: String = """
            # Leka - Educational Content
            # Copyright 2023 APF Frdance handicap
            # SPDX-License-Identifier: Apache-2.0

            # yaml-language-server: $schema=../Specs/schema/activity/v1.0.0/activity.schema.json

            schema:
              $ref: "../Specs/schema/activity/v1.0.0/activity.schema.json"

            uuid: 3ff93edc-576c-450c-acbc-xxxxxxxxxxxx
            name: code_name_of_the_activity
            """

        // Then
        let result = ActivityValidator.checkSchemaReferences(content: content)
        XCTAssertEqual(result, .success)
    }

    func test_shouldReturnErrorWhenYamlLanguageServerIsWrong() {
        // Given

        // When
        let content: String = """
            # Leka - Educational Content
            # Copyright 2023 APF Frdance handicap
            # SPDX-License-Identifier: Apache-2.0

            # yaml-language-server: $schema=../Specs/schema/activity/WRONG/PATH/AND/FILENAME.json

            schema:
              $ref: "../Specs/schema/activity/v1.0.0/activity.schema.json"

            uuid: 3ff93edc-576c-450c-acbc-xxxxxxxxxxxx
            name: code_name_of_the_activity
            """

        // Then
        let result = ActivityValidator.checkSchemaReferences(content: content)
        let expected = ActivityValidator.Status.schemaReferencesAreDifferent(
            yslSchema: "../Specs/schema/activity/WRONG/PATH/AND/FILENAME.json",
            ymlSchema: "../Specs/schema/activity/v1.0.0/activity.schema.json")

        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenSchemaRefIsWrong() {
        // Given

        // When
        let content: String = """
            # Leka - Educational Content
            # Copyright 2023 APF Frdance handicap
            # SPDX-License-Identifier: Apache-2.0

            # yaml-language-server: $schema=../Specs/schema/activity/v1.0.0/activity.schema.json

            schema:
              $ref: "../Specs/schema/activity/WRONG/PATH/AND/FILENAME.json"

            uuid: 3ff93edc-576c-450c-acbc-xxxxxxxxxxxx
            name: code_name_of_the_activity
            """

        // Then
        let result = ActivityValidator.checkSchemaReferences(content: content)
        let expected = ActivityValidator.Status.schemaReferencesAreDifferent(
            yslSchema: "../Specs/schema/activity/v1.0.0/activity.schema.json",
            ymlSchema: "../Specs/schema/activity/WRONG/PATH/AND/FILENAME.json")

        XCTAssertEqual(result, expected)
    }

    func test_shouldReturnErrorWhenYamlLanguageServerIsMissingOrWrong() {
        // Given

        // When
        let content: String = """
            # Leka - Educational Content
            # Copyright 2023 APF Frdance handicap
            # SPDX-License-Identifier: Apache-2.0

            # missing or wrong yaml language server

            schema:
              $ref: "../Specs/schema/activity/v1.0.0/activity.schema.json"

            uuid: 3ff93edc-576c-450c-acbc-xxxxxxxxxxxx
            name: code_name_of_the_activity
            """

        // Then
        let result = ActivityValidator.checkSchemaReferences(content: content)
        XCTAssertEqual(result, .missingYamlLanguageServerSchema)
    }

}
