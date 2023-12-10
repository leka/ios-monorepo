// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// swift-format-ignore: AlwaysUseLowerCamelCase
// swiftlint:disable identifier_name

public enum l10n {
    public static func LocalizedString(
        _ key: StaticString, value: String.LocalizationValue, comment: StaticString
    )
        -> AttributedString
    {
        let string = String(localized: key, defaultValue: value, comment: comment)
        let markdown =
            (try? AttributedString(
                markdown: string,
                options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
            ))
            ?? AttributedString(string)
        return markdown
    }

    public static func LocalizedStringInterpolation(
        _ key: StaticString, value: String.LocalizationValue, comment: StaticString
    ) -> (
        (CVarArg...) -> AttributedString
    ) {
        func localizedArgsOnly(_ arguments: CVarArg...) -> AttributedString {
            let format = String(localized: key, defaultValue: value, comment: comment)
            let string = String(format: format, arguments: arguments)
            let markdown =
                (try? AttributedString(
                    markdown: string,
                    options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
                )) ?? AttributedString(string)
            return markdown
        }

        return localizedArgsOnly
    }
}

// swiftlint:enable identifier_name
