// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// swift-format-ignore: AlwaysUseLowerCamelCase
// swiftlint:disable identifier_name

public enum l10n {

    public static func LocalizedString(_ key: StaticString, value: String.LocalizationValue, comment: StaticString)
        -> String
    {
        String(localized: key, defaultValue: value, comment: comment)
    }

    public static func LocalizedStringInterpolation(
        _ key: StaticString, value: String.LocalizationValue, comment: StaticString
    ) -> (
        (CVarArg...) -> String
    ) {
        func localizedArgsOnly(_ arguments: CVarArg...) -> String {
            let format = String(localized: key, defaultValue: value, comment: comment)
            let string = String(format: format, arguments: arguments)
            return string
        }

        return localizedArgsOnly
    }

}

// swiftlint:enable identifier_name
