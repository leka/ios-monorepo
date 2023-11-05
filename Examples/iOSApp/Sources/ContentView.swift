// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Module
import SwiftUI

// swiftlint:disable type_name nesting line_length identifier_name

extension String {

    static func localized(_ key: String, value: String, comment: String) -> String {
        NSLocalizedString(key, value: value, comment: comment)
    }

    func localized(value: String, comment: String) -> String {
        NSLocalizedString(self, value: value, comment: comment)
    }

}

func Localized(_ key: StaticString, value: String.LocalizationValue, comment: StaticString) -> String {
    String(localized: key, defaultValue: value, comment: comment)
}

func LocalizedInterpolation(_ key: StaticString, value: String.LocalizationValue, comment: StaticString) -> (
    (CVarArg...) -> String
) {
    func localizedArgsOnly(_ arguments: CVarArg...) -> String {
        let format = String(localized: key, defaultValue: value, comment: comment)
        let string = String(format: format, arguments: arguments)
        return string
    }

    return localizedArgsOnly
}

enum l10n {

    static let NSLocalizedStringNoDefault = NSLocalizedString("ns_localized_string_NO_default", comment: "")

    static let NSLocalizedStringWithDefault = NSLocalizedString(
        "ns_localized_string_WITH_default", value: "👋 DEFAULT ns_localized_string_WITH_default",
        comment: "NSLocalizedString with default")

    static let StringSelfDotLocalizedNoDefault = "string_self_dot_localized_NO_default"
        .localized(value: "", comment: "")

    static let StringSelfDotLocalizedWithDefault = "string_self_dot_localized_WITH_default"
        .localized(value: "👋 DEFAULT string_self_dot_localized_WITH_default", comment: "")

    static let StringLocalizedInitNoDefault = String(localized: "string_localized_init_NO_default")

    static let StringLocalizedInitWithDefault = String(
        localized: "string_localized_init_WITH_default", defaultValue: "👋 DEFAULT string_localized_init_WITH_default")

    static let FuncLocalizedNoDefault = Localized("func_localized_NO_default", value: "", comment: "")

    static let FuncLocalizedWithDefault = Localized(
        "func_localized_WITH_default", value: "👋 DEFAULT func_localized_WITH_default", comment: "")

    static let FuncLocalizedInterpolation = LocalizedInterpolation(
        "fun_localized_interpolation",
        value: "👋 DEFAULT fun_localized_interpolation - test: %@ - int: %lld - float: %f ", comment: "")

}

struct ContentView: View {
    @Environment(\.locale) var locale

    let nameValue = "John Doe"
    let intValue = 42
    let floatValue = 3.14

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(verbatim: "Current locale: \(locale)")
                .font(.largeTitle)

            VStack(alignment: .leading) {
                Text(verbatim: "verbatim_default_string")
                    .bold()
                Text(verbatim: "verbatim_default_string")
            }

            VStack(alignment: .leading) {
                Text(verbatim: "default_string")
                    .bold()
                Text("default_string")
            }

            VStack(alignment: .leading) {
                Text(verbatim: "ns_localized_string_NO_default")
                    .bold()
                Text(l10n.NSLocalizedStringNoDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "ns_localized_string_WITH_default")
                    .bold()
                Text(l10n.NSLocalizedStringWithDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "string_self_dot_localized_NO_default")
                    .bold()
                Text(l10n.StringSelfDotLocalizedNoDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "string_self_dot_localized_WITH_default")
                    .bold()
                Text(l10n.StringSelfDotLocalizedWithDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "string_localized_init_NO_default")
                    .bold()
                Text(l10n.StringLocalizedInitNoDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "string_localized_init_WITH_default")
                    .bold()
                Text(l10n.StringLocalizedInitWithDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "func_localized_NO_default")
                    .bold()
                Text(l10n.FuncLocalizedNoDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "func_localized_WITH_default")
                    .bold()
                Text(l10n.FuncLocalizedWithDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "fun_localized_interpolation")
                    .bold()
                Text(l10n.FuncLocalizedInterpolation(nameValue, intValue, floatValue))
            }

        }
    }
}

#Preview {
    HStack(spacing: 80) {
        ContentView()
            .environment(\.locale, .init(identifier: "en"))

        Divider()

        ContentView()
            .environment(\.locale, .init(identifier: "fr"))
    }
}

// swiftlint:enable type_name nesting line_length identifier_name
