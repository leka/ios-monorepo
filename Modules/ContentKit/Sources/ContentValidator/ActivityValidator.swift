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

        case missingLocales(locales: Set<String>)
        case unexpectedLocales(locales: Set<String>)
        case missingAndUnexpectedLocales(missing: Set<String>, unexpected: Set<String>)
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

    public static func checkLocalesInL10n(content: String) -> Status {
        guard let yaml = try? Yams.load(yaml: content) as? [String: Any],
            let localesExpected = yaml["locales"] as? [String],
            let l10n = yaml["l10n"] as? [[String: Any]]
        else {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkLocalesInL10n... ❌")
            print("     cannot parse yaml data:\n\(content)")
            return .cannotParseYamlData(content: content)
        }

        var localesAvailable: [String] = []
        for localization in l10n {
            if let locale = localization["locale"] as? String {
                localesAvailable.append(locale)
            }
        }

        let localesMissing = Set(localesExpected).subtracting(localesAvailable)
        let localesUnexpected = Set(localesAvailable).subtracting(localesExpected)

        if localesExpected.sorted() == localesAvailable.sorted() {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkLocalesInL10n... ✅")
            return .success
        }

        if !localesMissing.isEmpty {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkLocalesInL10n... ❌")
            print("     missing: \(localesMissing)")
            return .missingLocales(locales: localesMissing)
        }

        if !localesUnexpected.isEmpty {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkLocalesInL10n... ❌")
            print("     unexpected: \(localesUnexpected)")
            return .unexpectedLocales(locales: localesUnexpected)
        }

        return .success
    }

    public static func checkLocalesInGameplay(content: String) -> Status {
        guard let yaml = try? Yams.load(yaml: content) as? [String: Any],
            let localesExpected = yaml["locales"] as? [String],
            let gameplay = yaml["gameplay"] as? [String: Any]
        else {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkLocalesInGameplay... ❌")
            print("     cannot parse yaml data:\n\(content)")
            return .cannotParseYamlData(content: content)
        }

        var localesAvailable: [[String]] = []

        if let sequence = gameplay["sequence"] as? [[String: Any]] {
            for step in sequence {
                guard let instruction = step["instruction"] as? [[String: Any]] else {
                    continue
                }

                var stepLocales: [String] = []

                for locale in instruction {

                    if let locale = locale["locale"] as? String {
                        stepLocales.append(locale)
                    }
                }

                localesAvailable.append(stepLocales)
            }
        } else if let sequences = gameplay["sequences"] as? [[String: Any]] {
            for sequence in sequences {
                guard let sequence = sequence["sequence"] as? [[String: Any]] else {
                    continue
                }

                for step in sequence {
                    guard let instruction = step["instruction"] as? [[String: Any]] else {
                        continue
                    }

                    var stepLocales: [String] = []

                    for locale in instruction {

                        if let locale = locale["locale"] as? String {
                            stepLocales.append(locale)
                        }
                    }

                    localesAvailable.append(stepLocales)
                }
            }
        } else {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkLocalesInGameplay... ❌")
            print("     cannot parse yaml data:\n\(content)")
            return .cannotParseYamlData(content: content)
        }

        var localesMissing: Set<String> = []
        var localesUnexpected: Set<String> = []

        for locales in localesAvailable {
            let missing = Set(localesExpected).subtracting(locales)
            let unexpected = Set(locales).subtracting(localesExpected)

            localesMissing.formUnion(missing)
            localesUnexpected.formUnion(unexpected)
        }

        if localesMissing.isEmpty && localesUnexpected.isEmpty {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkLocalesInL10n... ✅")
            return .success
        }

        if !localesMissing.isEmpty && !localesUnexpected.isEmpty {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkLocalesInL10n... ❌")
            print("     missing: \(localesMissing)")
            print("     unexpected: \(localesUnexpected)")
            return .missingAndUnexpectedLocales(missing: localesMissing, unexpected: localesUnexpected)
        }

        if !localesMissing.isEmpty {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkLocalesInL10n... ❌")
            print("     missing: \(localesMissing)")
            return .missingLocales(locales: localesMissing)
        }

        if !localesUnexpected.isEmpty {
            // TODO(@ladislas): Move print statements to reporter
            print(" - checkLocalesInL10n... ❌")
            print("     unexpected: \(localesUnexpected)")
            return .unexpectedLocales(locales: localesUnexpected)
        }

        return .success
    }

}
