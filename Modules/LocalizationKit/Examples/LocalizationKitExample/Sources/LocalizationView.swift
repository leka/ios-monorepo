// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

extension Locale {
    static let enUS = Locale(identifier: "en_US")
    static let enCA = Locale(identifier: "en_CA")
    static let frFR = Locale(identifier: "fr_FR")
    static let frCA = Locale(identifier: "fr_CA")
}

extension l10n {
    static let localizedStringNoDefault = LocalizedString("localized_string_NO_default", value: "", comment: "")

    static let localizedStringWithDefault = LocalizedString(
        "localized_string_WITH_default", value: "⛳ DEFAULT localized_string_WITH_default", comment: ""
    )

    static let localizedStringInterpolation = LocalizedStringInterpolation(
        "localized_string_interpolation",
        value: "⛳ DEFAULT localized_string_interpolation - text: %@ - int: %lld - float: %f", comment: ""
    )

    static let localizedStringWithMarkdown = LocalizedString(
        "localized_string_with_markdown", value: "⛳ **DEFAULT** *localized_string_with_markdown*", comment: ""
    )

    static let localizedStringInterpolationWithMarkdown = LocalizedStringInterpolation(
        "localized_string_interpolation_with_markdown",
        value:
        "⛳ **DEFAULT** *localized_string_interpolation_with_markdown* - **text: %@** - *int: %lld* - ***float: %f***",
        comment: ""
    )
}

// MARK: - LocalizationView

struct LocalizationView: View {
//    @Environment(\.locale) var locale
    let language = l10n.language

    let nameValue = "John *Doe* [link]"
    let intValue = 42
    let floatValue = 3.14

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(verbatim: "Current language: \(l10n.language)")
                .font(.largeTitle)
            Text(verbatim: "Current locale: \(Locale.current)")
                .font(.largeTitle)

            VStack(alignment: .leading) {
                Text(verbatim: "localized_string_NO_default")
                    .bold()
                Text(l10n.localizedStringNoDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "localized_string_WITH_default")
                    .bold()
                Text(l10n.localizedStringWithDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "localized_string_interpolation")
                    .bold()
                Text(l10n.localizedStringInterpolation(self.nameValue, self.intValue, self.floatValue))
            }

            VStack(alignment: .leading) {
                Text(verbatim: "localized_string_with_markdown")
                    .bold()
                Text(l10n.localizedStringWithMarkdown)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "localized_string_interpolation_with_markdown")
                    .bold()
                Text(l10n.localizedStringInterpolationWithMarkdown(self.nameValue, self.intValue, self.floatValue))
            }
        }
        .onAppear {
            struct Widget {
                let locale: Locale
                let value: String
                var language: Locale.LanguageCode { self.locale.language.languageCode! }
            }

            let widgets: [Widget] = [
                Widget(locale: .frFR, value: "Bonjour"),
                Widget(locale: .frFR, value: "Monde"),
                Widget(locale: .frFR, value: "Ananas"),
                Widget(locale: .enUS, value: "Hello"),
                Widget(locale: .enUS, value: "World"),
                Widget(locale: .enUS, value: "Pineapple"),
            ]

            widgets.filter { $0.language == l10n.language }.forEach {
                print($0)
            }

            print("bundle: \(Bundle.main.preferredLocalizations[0])")
            print("preferred: \(l10n.preferred)")
            print("locale: \(l10n.locale)")
            print("language: \(l10n.language)")
        }
    }
}

#Preview {
    VStack(spacing: 80) {
        LocalizationView()
            .environment(\.locale, .init(identifier: "en"))

        LocalizationView()
            .environment(\.locale, .init(identifier: "fr"))
    }
}
