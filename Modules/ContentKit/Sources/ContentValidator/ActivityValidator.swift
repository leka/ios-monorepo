// Leka - iOS Monorepo
// Copyright 2023 APF Frdance handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Yams

public enum ActivityValidator {

    public enum Status: Equatable {
        case success

        case cannotParseYamlData(content: String)

        case missingYamlLanguageServerSchema
        case badYamlLanguageServerSchemaRegex(regex: String)
        case schemaReferencesAreDifferent(yslSchema: String, ymlSchema: String)
    }

    public static func checkSchemaReferences(content: String) -> Status {
        let regexString: String = "(?<=# yaml-language-server: \\$schema=).*"

        guard let regex = try? NSRegularExpression(pattern: regexString) else {
            return .badYamlLanguageServerSchemaRegex(regex: regexString)
        }

        var ylsSchema: String?

        content.enumerateLines { line, stop in
            if let match = regex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)),
                let range = Range(match.range, in: line)
            {
                ylsSchema = String(line[range])
                stop = true
            }
        }

        guard let ylsSchema = ylsSchema else {
            return .missingYamlLanguageServerSchema
        }

        guard let yaml = try? Yams.load(yaml: content) as? [String: Any],
            let ymlSchema = yaml["schema"] as? [String: Any],
            let ymlSchemaRef = ymlSchema["$ref"] as? String
        else {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkSchemaReferences... ❌")
            print("     cannot parse yaml data:\n\(content)")
            return .cannotParseYamlData(content: content)
        }

        guard ylsSchema == ymlSchemaRef else {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkSchemaReferences... ❌")
            print("     yls_schema: \(ylsSchema)")
            print("     yml_schema: \(ymlSchemaRef)")
            return .schemaReferencesAreDifferent(yslSchema: ylsSchema, ymlSchema: ymlSchemaRef)
        }

        // TODO(@ladislas): Move print statements to reporter
        print(" - checkSchemaReferences... ✅")

        return .success
    }

}
