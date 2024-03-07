// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// swift-format-ignore: AlwaysUseLowerCamelCase
// swiftlint:disable identifier_name

// ? LOCALIZED_STRING_MACRO_NAMES
// ? See https://forums.developer.apple.com/forums/thread/736941
// ? Format
// ? func NSLocalizedString(
// ?     _ key: String,
// ?     tableName: String? = nil,
// ?     bundle: Bundle = Bundle.main,
// ?     value: String = "",
// ?     comment: String
// ? ) -> String

public extension l10n {
    static func LocalizedString(
        _ key: StaticString, bundle: Bundle? = nil, value: String.LocalizationValue, comment: StaticString, dsoHandle: UnsafeRawPointer = #dsohandle
    )
        -> AttributedString
    {
        var dlInformation = dl_info()
        _ = dladdr(dsoHandle, &dlInformation)

        let path = String(cString: dlInformation.dli_fname)
        let url = URL(fileURLWithPath: path).deletingLastPathComponent()
        let bundle = bundle ?? Bundle(url: url)

        let string = String(localized: key, defaultValue: value, bundle: bundle, comment: comment)
        let markdown =
            (try? AttributedString(
                markdown: string,
                options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
            ))
            ?? AttributedString(string)
        return markdown
    }

    static func LocalizedStringInterpolation(
        _ key: StaticString, bundle: Bundle? = nil, value: String.LocalizationValue, comment: StaticString, dsoHandle: UnsafeRawPointer = #dsohandle
    ) -> (
        (CVarArg...) -> AttributedString
    ) {
        func localizedArgsOnly(_ arguments: CVarArg...) -> AttributedString {
            var dlInformation = dl_info()
            _ = dladdr(dsoHandle, &dlInformation)

            let path = String(cString: dlInformation.dli_fname)
            let url = URL(fileURLWithPath: path).deletingLastPathComponent()
            let bundle = bundle ?? Bundle(url: url)

            let format = String(localized: key, defaultValue: value, bundle: bundle, comment: comment)
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
